# TNIC-hw

## Trusted NIC

### Overview

T-NIC is built on [Coyote](https://github.com/fpgasystems/Coyote), a framework providing OS abstractions for FPGAs.
This repo contains HDL code for the attestation kernel that is integrated into Coyote and patches for the host software.

### Build hardware for FPGA

First, make sure you have Vivado installed (tested with version 2022.1) and a free license for the [UltraScale+ Integrated 100G Ethernet Subsystem](https://www.xilinx.com/products/intellectual-property/cmac_usplus.html).

Clone the Coyote and TNIC-hw repos:

```sh
git clone https://github.com/fpgasystems/Coyote.git
```

```sh
git clone https://github.com/TUM-DSE/TNIC-hw.git 
```

Checkout the right branch of TNIC-hw:

```sh
cd TNIC-hw 
```

If you're on NixOS, get the necessary packages:

```sh
xilinx-shell
```

```sh
nix-shell
```

Checkout the right commit of Coyote:

```sh
cd ../Coyote && git checkout 462988605b83274f8f31b4e3f9e20a99c14c430c
```

Build the foundational Vivado project:

```sh
mkdir hw/build && cd hw/build
```

```sh
cmake .. -DFDEV_NAME=u280 -DEXAMPLE=perf_rdma_host
```

```sh
make shell
```

Copy the user logic files from TNIC-hw:

```sh
cd ../.. && cp ../TNIC-hw/replacingLastPacket/hmac/{abcd.sv,abcd2.sv,check_sha.sv,inputFIFODuplicate.sv,replace_last_packet_with_sha.sv,add_metadata.sv,check_metadata.sv} hw/build
```

```sh
cp ../TNIC-hw/replacingLastPacket/hmac/vitis/verilog/* hw/build/
```

```sh
cp ../TNIC-hw/replacingLastPacket/hmac/user_logic_c0_0.sv hw/build/lynx/hdl/config_0/
```

```sh
cp ../TNIC-hw/replacingLastPacket/hmac/perf_rdma_host_c0_0.svh hw/hdl/operators/examples/perf_rdma/
```

To enable the attestation kernel only for sending or receiving, comment out the `abcd2 a1` or `abcd a2` module in `hw/build/lynx/hdl/config_0/user_logic_c0_0.sv` respectively and change the `AXISR_ASSIGN` macros in `hw/hdl/operators/examples/perf_rdma/perf_rdma_host_c0_0.svh`.

Open the project with Vivado (GUI):

```sh
cd hw/build && vivado lynx/lynx.xpr
```

Manually add the files in `hw/build` copied over from TNIC-hw in Vivado (File -> Add Sources -> Next -> Add Files -> Select all .v and .sv files -> OK -> Finish).

Generate the bitstream (Flow -> Generate Bitstream).

### Build hardware for simulation

The user logic of Coyote (the attestation kernel in our case) can be simulated in Vivado.

Follow all steps in [Build hardware for FPGA](#build-hardware-for-fpga) except generating the bitstream, but instead of `make shell` use:

```sh
make sim
```

Also, the project should be built in `hw/build/sim`, so open it with:

```sh
vivado sim/lynx.xpr
```

After adding the files from TNIC-hw, create the FIFO IP that the user logic uses with the Vivado TCL console:

```tcl
create_ip -name axis_data_fifo -vendor xilinx.com -library ip -version 2.0 -module_name axisr_data_fifo_512
```

```tcl
set_property -dict [list CONFIG.TDATA_NUM_BYTES {64} CONFIG.FIFO_DEPTH {512} CONFIG.HAS_TKEEP {1} CONFIG.HAS_TLAST {1}  CONFIG.TID_WIDTH {6}] [get_ips axisr_data_fifo_512]
```

### Build software

This section assumes you're on NixOS.
Run the commands on the machine with the U280 FPGA.

If you haven't done so already, go to the TNIC-hw directory and get the necessary packages:

```sh
nix-shell
```

Go to the Coyote directory and apply the patch for the host software:

```sh
git apply ../TNIC-hw/coyote-tnic.patch
```

Find the version of the Linux kernel currently running:

```sh
uname -r
```

Build the driver. Replace `6_8` with the current kernel version. The driver has been tested with version 6.8.

```sh
cd driver && make -C $(nix-build -E '(import <nixpkgs> {}).linuxPackages_6_8.kernel.dev' --no-out-link)/lib/modules/*/build M=$(pwd)
```

If that did not work, you can look for the right directory using find:

```sh
find /nix -type d -regex ".*linux-6\.8\.9-dev"
```

and replace `KERNELDIR` in the driver Makefile with that path, for example:

```makefile
KERNELDIR ?= /nix/store/h2f96f8kgzs3kv6k01l09a4ajz02f6x8-linux-6.8.9-dev/lib/modules/6.8.9/build
```

Build the software:

```sh
mkdir ../sw/build && cd ../sw/build
```

```sh
cmake .. -DTARGET_DIR=$(realpath ../examples/perf_rdma)
```

```sh
make
```

### Run

To run the system, you need two machines with U280 FPGAs that are directly connected via a QSFP cable.
At our chair, we currently use Amy and Clara.

First, go to the Coyote directory and find the bitstream:

```sh
find . -name 'cyt_top\.bit'
```

Replace the argument to PROGRAM.FILE in TNIC-hw/stream.tcl with the path to cyt_top.bit.
This path shouldn't change for future builds, so you just have to adjust it once.

Remove the current driver:

```sh
sudo rmmod coyote_drv
```

Reset the PCIe interface:

```sh
sudo bash ./sw/util/hot_reset.sh "e1:00.0"
```

If you haven't done so already, get the Xilinx tools:

```sh
xilinx-shell
```

Program the FPGA:

```sh
vivado -mode tcl -source ../TNIC-hw/stream.tcl
```

Reset PCIe interface again:

```sh
sudo bash ./sw/util/hot_reset.sh "e1:00.0"
```

Run only on Amy:

```sh
sudo insmod ./driver/coyote_drv.ko ip_addr_q0=0a000001 mac_addr_q0=000A350E24D6
```

```sh
sudo DEVICE_1_IP_ADDRESS_0=10.0.0.1 ./sw/build/main -w 1
```

Run only on Clara:

```sh
sudo insmod ./driver/coyote_drv.ko ip_addr_q0=0a000002 mac_addr_q0=000A350E24F2
```

```sh
sudo DEVICE_1_IP_ADDRESS_0=10.0.0.2 ./sw/build/main -t 131.159.102.20 -w 1
```

A simple demo should run that measures latency and throughput.
A snapshot of the data in host memory is saved after each benchmark step in the file `hmem-*.txt`, where `*` depends on the mode (RDMA or local operation) and for RDMA if the machine is the server (Amy) or the initiator (Clara).

You can find the code in `sw/examples/perf_rdma/main.cpp`.
To rebuild the software, run `make` in `sw/build` again.
Sometimes, it may be necessary to repeat the steps starting from "Remove the current driver" to make a new software build work.
