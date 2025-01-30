`timescale 1ns / 1ps

import lynxTypes::*;

`include "axi_macros.svh"
`include "lynx_macros.svh"

/**
 * User logic
 *
 */
module design_user_logic_c0_0 (
    // AXI4L CONTROL
    AXI4L.s                     axi_ctrl,

    // DESCRIPTOR BYPASS
    metaIntf.m                  bpss_rd_req,
    metaIntf.m                  bpss_wr_req,
    metaIntf.s                  bpss_rd_done,
    metaIntf.s                  bpss_wr_done,

    // AXI4S HOST STREAMS
    AXI4SR.s                    axis_host_0_sink,
    AXI4SR.m                    axis_host_0_src,

    // RDMA QSFP0 CMD
    metaIntf.s                  rdma_0_rd_req,
    metaIntf.s                  rdma_0_wr_req,

    // AXI4S RDMA QSFP0 STREAMS
    AXI4SR.s                    axis_rdma_0_sink,
    AXI4SR.m                    axis_rdma_0_src,

    // Clock and reset
    input  wire                 aclk,
    input  wire[0:0]            aresetn
);

/* -- Tie-off unused interfaces and signals ----------------------------- */
//always_comb axi_ctrl.tie_off_s();
//always_comb bpss_rd_req.tie_off_m();
//always_comb bpss_wr_req.tie_off_m();
//always_comb bpss_rd_done.tie_off_s();
//always_comb bpss_wr_done.tie_off_s();
//always_comb axis_host_0_sink.tie_off_s();
//always_comb axis_host_0_src.tie_off_m();

//always_comb rdma_0_rd_req.tie_off_s();
//always_comb rdma_0_wr_req.tie_off_s();
//always_comb axis_rdma_0_sink.tie_off_s();
//always_comb axis_rdma_0_src.tie_off_m();

/* -- USER LOGIC -------------------------------------------------------- */
`include "perf_rdma_host_c0_0.svh"

AXI4SR axis_rdma_0_sink2();
AXI4SR axis_host_sink2();

AXI4SR axis_attest_in();
AXI4SR axis_attest_out();
AXI4SR axis_verify_in();
AXI4SR axis_verify_out();

// Verification
abcd2 a1(
    .aclk  (aclk),
    .areset(aresetn),

    .m_axis_host(axis_verify_out),
    .s_axis_host(axis_verify_in)
);

// Attestation
abcd a2(
    .aclk  (aclk),
    .areset(aresetn),

    .m_axis_host(axis_attest_out),
    .s_axis_host(axis_attest_in)
);

// Normal RDMA operation: host_0 => fpga_0 (attest) => network => fpga_1 (verify) => host_1
localparam logic [1:0] MODE_RDMA = 2'b00;
// Attest data locally: host_0 => fpga_0 (attest) => host_0
localparam logic [1:0] MODE_LOOPBACK_ATTEST = 2'b01;
// Verify data locally: host_0 => fpga_0 (verify) => host_0
localparam logic [1:0] MODE_LOOPBACK_VERIFY = 2'b10;

// Set by AXI logic below
logic [1:0] mode;

// Route AXI-Stream data based on mode
always_comb begin
    case (mode)
        MODE_LOOPBACK_ATTEST: begin
            // Host => attestation
            axis_attest_in.tvalid = axis_host_sink2.tvalid;
            axis_host_sink2.tready = axis_attest_in.tready;
            axis_attest_in.tdata = axis_host_sink2.tdata;
            axis_attest_in.tkeep = axis_host_sink2.tkeep;
            axis_attest_in.tid = axis_host_sink2.tid;
            axis_attest_in.tlast = axis_host_sink2.tlast;
            // Attestation => host
            axis_host_0_src.tvalid = axis_attest_out.tvalid;
            axis_attest_out.tready = axis_host_0_src.tready;
            axis_host_0_src.tdata = axis_attest_out.tdata;
            axis_host_0_src.tkeep = axis_attest_out.tkeep;
            axis_host_0_src.tid = axis_attest_out.tid;
            axis_host_0_src.tlast = axis_attest_out.tlast;
            // Verification in and out blocked
            axis_verify_in.tie_off_m();
            axis_verify_out.tie_off_s();
        end
        MODE_LOOPBACK_VERIFY: begin
            // Attestation in and out blocked
            axis_attest_in.tie_off_m();
            axis_attest_out.tie_off_s();
            // Host => verification
            axis_verify_in.tvalid = axis_host_sink2.tvalid;
            axis_host_sink2.tready = axis_verify_in.tready;
            axis_verify_in.tdata = axis_host_sink2.tdata;
            axis_verify_in.tkeep = axis_host_sink2.tkeep;
            axis_verify_in.tid = axis_host_sink2.tid;
            axis_verify_in.tlast = axis_host_sink2.tlast;
            // Verification => host
            axis_host_0_src.tvalid = axis_verify_out.tvalid;
            axis_verify_out.tready = axis_host_0_src.tready;
            axis_host_0_src.tdata = axis_verify_out.tdata;
            axis_host_0_src.tkeep = axis_verify_out.tkeep;
            axis_host_0_src.tid = axis_verify_out.tid;
            axis_host_0_src.tlast = axis_verify_out.tlast;
        end
        default: begin
            // Host => attestation
            axis_attest_in.tvalid = axis_host_sink2.tvalid;
            axis_host_sink2.tready = axis_attest_in.tready;
            axis_attest_in.tdata = axis_host_sink2.tdata;
            axis_attest_in.tkeep = axis_host_sink2.tkeep;
            axis_attest_in.tid = axis_host_sink2.tid;
            axis_attest_in.tlast = axis_host_sink2.tlast;
            // Attestation => RDMA
            axis_rdma_0_src.tvalid = axis_attest_out.tvalid;
            axis_attest_out.tready = axis_rdma_0_src.tready;
            axis_rdma_0_src.tdata = axis_attest_out.tdata;
            axis_rdma_0_src.tkeep = axis_attest_out.tkeep;
            axis_rdma_0_src.tid = axis_attest_out.tid;
            axis_rdma_0_src.tlast = axis_attest_out.tlast;
            // RDMA => verification
            axis_verify_in.tvalid = axis_rdma_0_sink2.tvalid;
            axis_rdma_0_sink2.tready = axis_verify_in.tready;
            axis_verify_in.tdata = axis_rdma_0_sink2.tdata;
            axis_verify_in.tkeep = axis_rdma_0_sink2.tkeep;
            axis_verify_in.tid = axis_rdma_0_sink2.tid;
            axis_verify_in.tlast = axis_rdma_0_sink2.tlast;
            // Verification => host
            axis_host_0_src.tvalid = axis_verify_out.tvalid;
            axis_verify_out.tready = axis_host_0_src.tready;
            axis_host_0_src.tdata = axis_verify_out.tdata;
            axis_host_0_src.tkeep = axis_verify_out.tkeep;
            axis_host_0_src.tid = axis_verify_out.tid;
            axis_host_0_src.tlast = axis_verify_out.tlast;
        end
    endcase
end

// AXI logic: copied from hw/hdl/operators/examples/perf_fpga/perf_fpga_slv.sv

// -- Decl ----------------------------------------------------------
// ------------------------------------------------------------------
// Constants
localparam integer N_REGS = 2;
localparam integer ADDR_LSB = $clog2(AXIL_DATA_BITS/8);
localparam integer ADDR_MSB = $clog2(N_REGS);
localparam integer AXI_ADDR_BITS = ADDR_LSB + ADDR_MSB;

// Internal registers
logic [AXI_ADDR_BITS-1:0] axi_awaddr;
logic axi_awready;
logic [AXI_ADDR_BITS-1:0] axi_araddr;
logic axi_arready;
logic [1:0] axi_bresp;
logic axi_bvalid;
logic axi_wready;
logic [AXIL_DATA_BITS-1:0] axi_rdata;
logic [1:0] axi_rresp;
logic axi_rvalid;

// Registers
logic [N_REGS-1:0][AXIL_DATA_BITS-1:0] slv_reg;
logic slv_reg_rden;
logic slv_reg_wren;
logic aw_en;

// -- Def -----------------------------------------------------------
// ------------------------------------------------------------------

// -- Register map -----------------------------------------------------------------------
// 0 (WR) : mode
localparam integer MODE_REG = 0;
// 1 (WR) : currently unused
localparam integer UNUSED_REG = 1;

// Write process
assign slv_reg_wren = axi_wready && axi_ctrl.wvalid && axi_awready && axi_ctrl.awvalid;

always_ff @(posedge aclk) begin
  if ( aresetn == 1'b0 ) begin
    slv_reg <= 0;
  end
  else begin
    if(slv_reg_wren) begin
      case (axi_awaddr[ADDR_LSB+:ADDR_MSB])
        MODE_REG:
          for (int i = 0; i < (AXIL_DATA_BITS/8); i++) begin
            if(axi_ctrl.wstrb[i]) begin
              slv_reg[MODE_REG][(i*8)+:8] <= axi_ctrl.wdata[(i*8)+:8];
            end
          end
        UNUSED_REG:
          for (int i = 0; i < (AXIL_DATA_BITS/8); i++) begin
            if(axi_ctrl.wstrb[i]) begin
              slv_reg[UNUSED_REG][(i*8)+:8] <= axi_ctrl.wdata[(i*8)+:8];
            end
          end
        default : ;
      endcase
    end
  end
end

// Read process
assign slv_reg_rden = axi_arready & axi_ctrl.arvalid & ~axi_rvalid;

always_ff @(posedge aclk) begin
  if( aresetn == 1'b0 ) begin
    axi_rdata <= 0;
  end
  else begin
    if(slv_reg_rden) begin
      axi_rdata <= 0;

      case (axi_araddr[ADDR_LSB+:ADDR_MSB])
        MODE_REG:
          axi_rdata[1:0] <= slv_reg[MODE_REG][1:0];
        UNUSED_REG:
          axi_rdata[63:0] <= slv_reg[UNUSED_REG][63:0];
        default: ;
      endcase
    end
  end
end

assign mode = slv_reg[MODE_REG][1:0];

// --------------------------------------------------------------------------------------
// AXI CTRL
// --------------------------------------------------------------------------------------
// Don't edit

// I/O
assign axi_ctrl.awready = axi_awready;
assign axi_ctrl.arready = axi_arready;
assign axi_ctrl.bresp = axi_bresp;
assign axi_ctrl.bvalid = axi_bvalid;
assign axi_ctrl.wready = axi_wready;
assign axi_ctrl.rdata = axi_rdata;
assign axi_ctrl.rresp = axi_rresp;
assign axi_ctrl.rvalid = axi_rvalid;

// awready and awaddr
always_ff @(posedge aclk) begin
  if ( aresetn == 1'b0 )
    begin
      axi_awready <= 1'b0;
      axi_awaddr <= 0;
      aw_en <= 1'b1;
    end
  else
    begin
      if (~axi_awready && axi_ctrl.awvalid && axi_ctrl.wvalid && aw_en)
        begin
          axi_awready <= 1'b1;
          aw_en <= 1'b0;
          axi_awaddr <= axi_ctrl.awaddr;
        end
      else if (axi_ctrl.bready && axi_bvalid)
        begin
          aw_en <= 1'b1;
          axi_awready <= 1'b0;
        end
      else
        begin
          axi_awready <= 1'b0;
        end
    end
end

// arready and araddr
always_ff @(posedge aclk) begin
  if ( aresetn == 1'b0 )
    begin
      axi_arready <= 1'b0;
      axi_araddr  <= 0;
    end
  else
    begin
      if (~axi_arready && axi_ctrl.arvalid)
        begin
          axi_arready <= 1'b1;
          axi_araddr  <= axi_ctrl.araddr;
        end
      else
        begin
          axi_arready <= 1'b0;
        end
    end
end

// bvalid and bresp
always_ff @(posedge aclk) begin
  if ( aresetn == 1'b0 )
    begin
      axi_bvalid  <= 0;
      axi_bresp   <= 2'b0;
    end
  else
    begin
      if (axi_awready && axi_ctrl.awvalid && ~axi_bvalid && axi_wready && axi_ctrl.wvalid)
        begin
          axi_bvalid <= 1'b1;
          axi_bresp  <= 2'b0;
        end
      else
        begin
          if (axi_ctrl.bready && axi_bvalid)
            begin
              axi_bvalid <= 1'b0;
            end
        end
    end
end

// wready
always_ff @(posedge aclk) begin
  if ( aresetn == 1'b0 )
    begin
      axi_wready <= 1'b0;
    end
  else
    begin
      if (~axi_wready && axi_ctrl.wvalid && axi_ctrl.awvalid && aw_en )
        begin
          axi_wready <= 1'b1;
        end
      else
        begin
          axi_wready <= 1'b0;
        end
    end
end

// rvalid and rresp (1Del?)
always_ff @(posedge aclk) begin
  if ( aresetn == 1'b0 )
    begin
      axi_rvalid <= 0;
      axi_rresp  <= 0;
    end
  else
    begin
      if (axi_arready && axi_ctrl.arvalid && ~axi_rvalid)
        begin
          axi_rvalid <= 1'b1;
          axi_rresp  <= 2'b0;
        end
      else if (axi_rvalid && axi_ctrl.rready)
        begin
          axi_rvalid <= 1'b0;
        end
    end
end

endmodule
