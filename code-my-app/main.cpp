#include "cDefs.hpp"

#include <atomic>
#include <chrono>
#include <cstring>
#include <fcntl.h>
#include <fmt/printf.h>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <malloc.h>
#include <random>
#include <signal.h>
#include <string>
#include <sys/time.h>
#include <thread>
#include <time.h>
#include <unistd.h>

#include <boost/program_options.hpp>

#include "cBench.hpp"
#include "ibvQpMap.hpp"

using namespace std;
using namespace std::chrono;
using namespace fpga;

/* Signal handler */
std::atomic<bool> stalled(false);
void gotInt(int) {
  fmt::print("[{}]\n", __func__);
  stalled.store(true);
}

/* Params */
constexpr auto const targetRegion = 0;
constexpr auto const qpId = 0;
constexpr auto const port = 18488;

/* Bench */
constexpr auto const defNBenchRuns = 1;
constexpr auto const defNRepsThr = 0;
constexpr auto const defNRepsLat = 1;
constexpr auto const defMinSize = 64;
constexpr auto const defMaxSize = 64 * 12;
constexpr auto const defOper = 1; /* RDMA_WRITE */

int main(int argc, char *argv[]) {
  // ---------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------

  // Sig handler
  struct sigaction sa;
  memset(&sa, 0, sizeof(sa));
  sa.sa_handler = gotInt;
  sigfillset(&sa.sa_mask);
  sigaction(SIGINT, &sa, NULL);

  // Read arguments
  boost::program_options::options_description programDescription("Options:");
  programDescription.add_options()(
      "tcpaddr,t", boost::program_options::value<string>(), "TCP conn IP")(
      "benchruns,b", boost::program_options::value<uint32_t>(),
      "Number of bench runs")("repst,r",
                              boost::program_options::value<uint32_t>(),
                              "Number of throughput repetitions within a run")(
      "repsl,r", boost::program_options::value<uint32_t>(),
      "Number of latency repetitions within a run")(
      "mins,n", boost::program_options::value<uint32_t>(),
      "Minimum transfer size")("maxs,x",
                               boost::program_options::value<uint32_t>(),
                               "Maximum transfer size")(
      "oper,w", boost::program_options::value<bool>(), "Read or Write");

  boost::program_options::variables_map commandLineArgs;
  boost::program_options::store(boost::program_options::parse_command_line(
                                    argc, argv, programDescription),
                                commandLineArgs);
  boost::program_options::notify(commandLineArgs);

  // Stat
  string tcp_mstr_ip;
  uint32_t n_bench_runs = defNBenchRuns;
  uint32_t n_reps_thr = defNRepsThr;
  uint32_t n_reps_lat = defNRepsLat;
  uint32_t min_size = defMinSize;
  uint32_t max_size = defMaxSize;
  bool oper = defOper;
  bool mstr = true;

  char const *env_var_ip = std::getenv("FPGA_0_IP_ADDRESS");
  if (env_var_ip == nullptr)
    throw std::runtime_error("IBV IP address not provided");
  string ibv_ip(env_var_ip);

  if (commandLineArgs.count("tcpaddr") > 0) {
    tcp_mstr_ip = commandLineArgs["tcpaddr"].as<string>();
    mstr = false;
  }

  if (commandLineArgs.count("benchruns") > 0)
    n_bench_runs = commandLineArgs["benchruns"].as<uint32_t>();
  if (commandLineArgs.count("repst") > 0)
    n_reps_thr = commandLineArgs["repst"].as<uint32_t>();
  if (commandLineArgs.count("repsl") > 0)
    n_reps_lat = commandLineArgs["repsl"].as<uint32_t>();
  if (commandLineArgs.count("mins") > 0)
    min_size = commandLineArgs["mins"].as<uint32_t>();
  if (commandLineArgs.count("maxs") > 0)
    max_size = commandLineArgs["maxs"].as<uint32_t>();
  if (commandLineArgs.count("oper") > 0)
    oper = commandLineArgs["oper"].as<bool>();

  uint32_t n_pages = (max_size + hugePageSize - 1) / hugePageSize;

  uint32_t size = min_size;

  PR_HEADER("PARAMS");
  if (!mstr) {
	  fmt::print("TCP master IP address: {}\n", tcp_mstr_ip);
    // std::cout << "TCP master IP address: " << tcp_mstr_ip << std::endl;
  }
  fmt::print("IBV IP address: {}\n", ibv_ip);
  std::cout << "IBV IP address: " << ibv_ip << std::endl;
  std::cout << "Number of allocated pages: " << n_pages << std::endl;
  std::cout << (oper ? "Write operation" : "Read operation") << std::endl;
  std::cout << "Min size: " << min_size << std::endl;
  std::cout << "Max size: " << max_size << std::endl;
  std::cout << "Number of throughput reps: " << n_reps_thr << std::endl;
  std::cout << "Number of latency reps: " << n_reps_lat << std::endl;
  std::cout << "Hugepage: " << hugePageSize << "\n";

  // Create  queue pairs
  ibvQpMap ictx;
  ictx.addQpair(qpId, targetRegion, ibv_ip, n_pages);
  mstr ? ictx.exchangeQpMaster(port)
       : ictx.exchangeQpSlave(tcp_mstr_ip.c_str(), port);
  ibvQpConn *iqp = ictx.getQpairConn(qpId);
  cProcess *cproc = iqp->getCProc();


  // local-mem to be send/written by RDMA-ops
  // uint64_t *hMem = (uint64_t *)iqp->getQpairStruct()->local.vaddr;
  int *hMem = reinterpret_cast<int*>(iqp->getQpairStruct()->local.vaddr);
  iqp->ibvSync(mstr);

  // Fill the data
  // We want the following inital memory (for testing):
  // Sender:
  // 33333 ... 3 (size bytes)
  // 44444 ... 4 (size bytes)
  // 55555 ... 5 (size bytes)
  // ....
  //
  // Receiver:
  // 99999 ... 9
  // 99999 ... 9
  // 99999 ... 9
  // 99999 ... 9
  // ...
  int fill = (mstr) ? 3 : 9;
  int k = 3;
  for (auto idx = 0; idx < max_size; idx++) {
    if (mstr) {
      hMem[idx] = k;
      if (((idx + 1) % size) == 0)
        k++;
    } else {
      hMem[idx] = fill;
    }
  }

  fmt::print("[{}] hMem={} {} filed w/ {}\n", __func__,
             reinterpret_cast<void *>(hMem), reinterpret_cast<uintptr_t>(hMem),
             fill);

  PR_HEADER("RDMA BENCHMARK");
  // Setup
  iqp->ibvClear();
  iqp->ibvSync(mstr);

  // Measurements
  // ----------------------------------------------------------------------------------
  if (mstr) {
    // Init RDMA structs
    struct ibvSge sg;
    struct ibvSendWr wr;

    memset(&sg, 0, sizeof(sg));
#if 1
    sg.type.rdma.local_offs = min_size * sizeof(int);
    sg.type.rdma.remote_offs = min_size * sizeof(int);
    sg.type.rdma.len = size * sizeof(int);
#endif
#if 0
    sg.type.rdma.local_offs = min_size;
    sg.type.rdma.remote_offs = min_size;
    sg.type.rdma.len = size;
#endif

    memset(&wr, 0, sizeof(wr));
    wr.sg_list = &sg;
    wr.num_sge = 1;
    wr.next = nullptr;
    wr.opcode = oper ? IBV_WR_RDMA_WRITE : IBV_WR_RDMA_READ;
    fmt::print("[{}] Initiator side will do {} of len={} bytes\n", __func__,
               (oper ? "IBV_WR_RDMA_WRITE" : "IBV_WR_RDMA_READ"),
               sg.type.rdma.len);
    // Inititator
    //
    // cproc->netDrop(1, 0, 0);
    // cproc->netDrop(0, 1, 0);

    // ---------------------------------------------------------------
    // Runs
    // ---------------------------------------------------------------
    cBench bench(n_bench_runs);
    uint32_t n_runs = 0;
#if 0
			// Reset
			iqp->ibvClear();
			iqp->ibvSync(mstr);
#endif

    auto benchmark_lat = [&]() {
      n_runs++;

      std::this_thread::sleep_for(1s);
      // Initiate and wait for completion
      for (int i = 0; i < n_reps_lat; i++) {
        iqp->ibvPostSend(&wr);
        std::this_thread::sleep_for(100ms);
        if (stalled.load())
          throw std::runtime_error("Stalled, SIGINT caught");
#if 0
					while (iqp->ibvDone() < (i + 1) + ((n_runs - 1) * n_reps_lat)) {
						if (stalled.load())
							throw std::runtime_error("Stalled, SIGINT caught");
					}

					wr.sg_list[0].type.rdma.local_offs += (max_size > min_size) ? min_size : 0;
					wr.sg_list[0].type.rdma.remote_offs += (max_size > min_size) ? min_size : 0;
#endif

        fmt::print(
            "[{}] post completed: writing to remote offset={} ({} bytes)\n",
            __func__, wr.sg_list[0].type.rdma.remote_offs,
            sg.type.rdma.len /*, iqp->qpair.local.vaddr*/);
        for (auto idx = 0; idx < max_size; idx++) {
          fmt::print("{}", hMem[idx]);
          if ((idx + 1) % size == 0)
            std::cout << "\n";
        }
        std::cout << "\n*****\n";
#if 1
        // std::this_thread::sleep_for(100ms);
        // Init RDMA structs
        struct ibvSge sg1;
        struct ibvSendWr wr1;

        memset(&sg1, 0, sizeof(sg1));
#if 1
        sg1.type.rdma.local_offs = max_size * sizeof(int) /2;
        sg1.type.rdma.remote_offs = max_size * sizeof(int) / 2;
        sg1.type.rdma.len = max_size * sizeof(int) /2;
#endif
#if 0
        sg1.type.rdma.local_offs = max_size/2;
        sg1.type.rdma.remote_offs = max_size/2;
        sg1.type.rdma.len = max_size/2;
#endif

        memset(&wr1, 0, sizeof(wr1));
        wr1.sg_list = &sg1;
        wr1.num_sge = 1;
        wr1.next = nullptr;
        wr1.opcode = IBV_WR_RDMA_WRITE;
        fmt::print("[{}] Initiator side will do {} of len={} bytes\n", __func__,
                   ("IBV_WR_RDMA_WRITE"), sg1.type.rdma.len);
        iqp->ibvPostSend(&wr1);
#endif
      }

      std::this_thread::sleep_for(100ms);
      hMem[max_size / 2 - 1] = 1; /* here add a faulty byte to check if the following RDMA_READ will overwrite properly */
      // Init RDMA structs
      struct ibvSge sg1;
      struct ibvSendWr wr1;

      memset(&sg1, 0, sizeof(sg1));
      sg1.type.rdma.local_offs = 0;
      sg1.type.rdma.remote_offs = 0;
      sg1.type.rdma.len = max_size;
#if 1
      sg1.type.rdma.len = max_size * sizeof(int);
#endif

      memset(&wr1, 0, sizeof(wr1));
      wr1.sg_list = &sg1;
      wr1.num_sge = 1;
      wr1.next = nullptr;
      wr1.opcode = IBV_WR_RDMA_READ;
      fmt::print("[{}] Initiator side will do {} of len={} bytes\n", __func__,
                 ("IBV_WR_RDMA_READ"), sg1.type.rdma.len);
      iqp->ibvPostSend(&wr1);
      std::this_thread::sleep_for(100ms);
      fmt::print(
          "[{}] post completed: read from remote offset={} ({} bytes)\n",
          __func__, wr1.sg_list[0].type.rdma.remote_offs,
          sg1.type.rdma.len /*, iqp->qpair.local.vaddr*/);
#if 0
				for (auto idx = 0; idx < sg1.type.rdma.len; idx++) {
					//					hMem[wr.sg_list[0].type.rdma.local_offs + idx] = k;
					fmt::print("{}", hMem[wr1.sg_list[0].type.rdma.local_offs + idx]);
						if ((idx+1) % size == 0)
							std::cout << "\n";
				}
				std::cout << "\n*****\n";
#endif
    };

    bench.runtime(benchmark_lat);
    std::cout << (bench.getAvg()) / (n_reps_lat * (1 + oper)) << " [ns]"
              << std::endl;

  } else {
    // Server
    fmt::print("[{}] Server side\n", __func__);
    if (oper) {
#if 0
				// Reset
				iqp->ibvClear();
				iqp->ibvSync(mstr);
#endif

      int offset = 0;
      fmt::print("[{}] reading local hMem\n", __func__);
      for (auto idx = 0; idx < max_size; idx++) {
        fmt::print("{}", hMem[idx]);
        if (((idx + 1) % size) == 0)
          fmt::print("\n");
      }

      fmt::print("[{}]\n", __func__);
      std::atomic<int> prev = iqp->ibvDone();
      while (true) {
        fmt::print("[{}] completed ops={}\n", __func__, iqp->ibvDone());
        std::this_thread::sleep_for(200ms);
        while (prev == iqp->ibvDone()) {
          std::this_thread::sleep_for(100ms);
          /*
             for (auto idx = 0; idx < max_size; idx++) {
             fmt::print("{}", hMem[idx]);
             }
             std::cout << "\n*****\n";
             */
          if (iqp->ibvDone() == 2)
            break;
          if (stalled.load())
            throw std::runtime_error("Stalled, SIGINT caught");
        }
        prev = iqp->ibvDone();
        /*
           for (auto idx = 0; idx < max_size; idx++) {
           fmt::print("{}", hMem[idx]);
           }
           */
        offset++;
        std::cout << "\n*****\n";
	// some artificial delay before finishing 
	if (offset == 10) {
          fmt::print("[{}] need to stop here\n", __func__);
          break;
        }
      }
    }
  }
  std::cout << std::endl;
  fmt::print("\n[{}] before cleanup let's print our local memory \n", __func__);
  std::this_thread::sleep_for(500ms);
  for (auto idx = 0; idx < max_size; idx++) {
    fmt::print("{}", hMem[idx]);
    if ((idx + 1) % size == 0)
      std::cout << "\n";
  }
  fmt::print("\n");

  // Done
  if (mstr) {
    iqp->sendAck(1);
    iqp->closeAck();
  } else {
    iqp->readAck();
    iqp->closeConnection();
  }

  return EXIT_SUCCESS;
}
