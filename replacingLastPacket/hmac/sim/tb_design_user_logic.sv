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

`ifdef EN_BPSS
    // DESCRIPTOR BYPASS
    metaIntf.m			        bpss_rd_req,
    metaIntf.m			        bpss_wr_req,
    metaIntf.s                  bpss_rd_done,
    metaIntf.s                  bpss_wr_done,

`endif
`ifdef EN_STRM
    // AXI4S HOST STREAMS
    AXI4SR.s                    axis_host_sink,
    AXI4SR.m                    axis_host_src,
`endif
`ifdef EN_MEM
    // AXI4S CARD STREAMS
    AXI4SR.s                    axis_card_sink,
    AXI4SR.m                    axis_card_src,
`endif
`ifdef EN_RDMA_0
    // RDMA QSFP0 CMD
    metaIntf.s			        rdma_0_rd_req,
    metaIntf.s 			        rdma_0_wr_req,

    // AXI4S RDMA QSFP0 STREAMS
    AXI4SR.s                    axis_rdma_0_sink,
    AXI4SR.m                    axis_rdma_0_src,
`ifdef EN_RPC
    // RDMA QSFP1 SQ
    metaIntf.m 			        rdma_0_sq,
    metaIntf.s                  rdma_0_rq,
`endif
`endif
`ifdef EN_RDMA_1
    // RDMA QSFP1 CMD
    metaIntf.s			        rdma_1_rd_req,
    metaIntf.s 			        rdma_1_wr_req,

    // AXI4S RDMA QSFP1 STREAMS
    AXI4SR.s                    axis_rdma_1_sink,
    AXI4SR.m                    axis_rdma_1_src,
`ifdef EN_RPC
    // RDMA QSFP1 SQ
    metaIntf.m 			        rdma_1_sq,
    metaIntf.s                  rdma_1_rq,
`endif
`endif
`ifdef EN_TCP_0
    // TCP/IP QSFP0 CMD
    metaIntf.m			        tcp_0_listen_req,
    metaIntf.s			        tcp_0_listen_rsp,
    metaIntf.m			        tcp_0_open_req,
    metaIntf.s			        tcp_0_open_rsp,
    metaIntf.m			        tcp_0_close_req,
    metaIntf.s			        tcp_0_notify,
    metaIntf.m			        tcp_0_rd_pkg,
    metaIntf.s			        tcp_0_rx_meta,
    metaIntf.m			        tcp_0_tx_meta,
    metaIntf.s			        tcp_0_tx_stat,

    // AXI4S TCP/IP QSFP0 STREAMS
    AXI4SR.s                    axis_tcp_0_sink,
    AXI4SR.m                    axis_tcp_0_src,
`endif
`ifdef EN_TCP_1
    // TCP/IP QSFP1 CMD
    metaIntf.m			        tcp_1_listen_req,
    metaIntf.s			        tcp_1_listen_rsp,
    metaIntf.m			        tcp_1_open_req,
    metaIntf.s			        tcp_1_open_rsp,
    metaIntf.m			        tcp_1_close_req,
    metaIntf.s			        tcp_1_notify,
    metaIntf.m			        tcp_1_rd_pkg,
    metaIntf.s			        tcp_1_rx_meta,
    metaIntf.m			        tcp_1_tx_meta,
    metaIntf.s			        tcp_1_tx_stat,

    // AXI4S TCP/IP QSFP1 STREAMS
    AXI4SR.s                    axis_tcp_1_sink,
    AXI4SR.m                    axis_tcp_1_src,
`endif
    // Clock and reset
    input  wire                 aclk,
    input  wire[0:0]            aresetn
);

/* -- Tie-off unused interfaces and signals ----------------------------- */
always_comb axi_ctrl.tie_off_s();
`ifdef EN_BPSS
always_comb bpss_rd_req.tie_off_m();
always_comb bpss_wr_req.tie_off_m();
always_comb bpss_rd_done.tie_off_s();
always_comb bpss_wr_done.tie_off_s();
`endif
`ifdef EN_STRM
always_comb axis_host_sink.tie_off_s();
always_comb axis_host_src.tie_off_m();
`endif
`ifdef EN_MEM
always_comb axis_card_sink.tie_off_s();
always_comb axis_card_src.tie_off_m();
`endif
`ifdef EN_RDMA_0
always_comb rdma_0_rd_req.tie_off_s();
always_comb rdma_0_wr_req.tie_off_s();
always_comb axis_rdma_0_sink.tie_off_s();
always_comb axis_rdma_0_src.tie_off_m();
`ifdef EN_RPC
always_comb rdma_0_sq.tie_off_m();
always_comb rdma_0_rq.tie_off_s();
`endif
`endif
`ifdef EN_RDMA_1
always_comb rdma_1_rd_req.tie_off_s();
always_comb rdma_1_wr_req.tie_off_s();
always_comb axis_rdma_1_sink.tie_off_s();
always_comb axis_rdma_1_src.tie_off_m();
`ifdef EN_RPC
always_comb rdma_1_sq.tie_off_m();
always_comb rdma_1_rq.tie_off_s();
`endif
`endif
`ifdef EN_TCP_0
always_comb tcp_0_listen_req.tie_off_m();
always_comb tcp_0_listen_rsp.tie_off_s();
always_comb tcp_0_open_req.tie_off_m();
always_comb tcp_0_open_rsp.tie_off_s();
always_comb tcp_0_close_req.tie_off_m();
always_comb tcp_0_notify.tie_off_s();
always_comb tcp_0_rd_pkg.tie_off_m();
always_comb tcp_0_rx_meta.tie_off_s();
always_comb tcp_0_tx_meta.tie_off_m();
always_comb tcp_0_tx_stat.tie_off_s();
always_comb axis_tcp_0_sink.tie_off_s();
always_comb axis_tcp_0_src.tie_off_m();
`endif
`ifdef EN_TCP_1
always_comb tcp_1_listen_req.tie_off_m();
always_comb tcp_1_listen_rsp.tie_off_s();
always_comb tcp_1_open_req.tie_off_m();
always_comb tcp_1_open_rsp.tie_off_s();
always_comb tcp_1_close_req.tie_off_m();
always_comb tcp_1_notify.tie_off_s();
always_comb tcp_1_rd_pkg.tie_off_m();
always_comb tcp_1_rx_meta.tie_off_s();
always_comb tcp_1_tx_meta.tie_off_m();
always_comb tcp_1_tx_stat.tie_off_s();
always_comb axis_tcp_1_sink.tie_off_s();
always_comb axis_tcp_1_src.tie_off_m();
`endif

/* -- USER LOGIC -------------------------------------------------------- */
AXI4SR axis_attest_in();
AXI4SR axis_attest_out();
AXI4SR axis_verify_in();
AXI4SR axis_verify_out();

// HMAC verification
abcd2 a1(

    // clock and reset
    .aclk(aclk),
    .areset(aresetn),

    .m_axis_host(axis_verify_out),
    .s_axis_host(axis_verify_in)
);

// HMAC attestation
abcd a2(

    // clock and reset
    .aclk(aclk),
    .areset(aresetn),

    .m_axis_host(axis_attest_out),
    .s_axis_host(axis_attest_in)
);

localparam logic [1:0] MODE_RDMA = 2'b00;
localparam logic [1:0] MODE_LOOPBACK_ATTEST = 2'b01;
localparam logic [1:0] MODE_LOOPBACK_VERIFY = 2'b10;

// Set manually for simulation
logic [1:0] mode = MODE_RDMA;

// Route AXI-Stream data based on mode
always_comb begin
    case (mode)
        MODE_LOOPBACK_ATTEST: begin
            // Host => attestation
            axis_attest_in.tvalid = axis_host_sink.tvalid;
            axis_host_sink.tready = axis_attest_in.tready;
            axis_attest_in.tdata = axis_host_sink.tdata;
            axis_attest_in.tkeep = axis_host_sink.tkeep;
            axis_attest_in.tid = axis_host_sink.tid;
            axis_attest_in.tlast = axis_host_sink.tlast;
            // Attestation => host
            axis_host_src.tvalid = axis_attest_out.tvalid;
            axis_attest_out.tready = axis_host_src.tready;
            axis_host_src.tdata = axis_attest_out.tdata;
            axis_host_src.tkeep = axis_attest_out.tkeep;
            axis_host_src.tid = axis_attest_out.tid;
            axis_host_src.tlast = axis_attest_out.tlast;
            // Verification in and out blocked
            axis_verify_in.tie_off_m();
            axis_verify_out.tie_off_s();
        end
        MODE_LOOPBACK_VERIFY: begin
            // Attestation in and out blocked
            axis_attest_in.tie_off_m();
            axis_attest_out.tie_off_s();
            // Host => verification
            axis_verify_in.tvalid = axis_host_sink.tvalid;
            axis_host_sink.tready = axis_verify_in.tready;
            axis_verify_in.tdata = axis_host_sink.tdata;
            axis_verify_in.tkeep = axis_host_sink.tkeep;
            axis_verify_in.tid = axis_host_sink.tid;
            axis_verify_in.tlast = axis_host_sink.tlast;
            // Verification => host
            axis_host_src.tvalid = axis_verify_out.tvalid;
            axis_verify_out.tready = axis_host_src.tready;
            axis_host_src.tdata = axis_verify_out.tdata;
            axis_host_src.tkeep = axis_verify_out.tkeep;
            axis_host_src.tid = axis_verify_out.tid;
            axis_host_src.tlast = axis_verify_out.tlast;
        end
        default: begin
            // Host => attestation
            axis_attest_in.tvalid = axis_host_sink.tvalid;
            axis_host_sink.tready = axis_attest_in.tready;
            axis_attest_in.tdata = axis_host_sink.tdata;
            axis_attest_in.tkeep = axis_host_sink.tkeep;
            axis_attest_in.tid = axis_host_sink.tid;
            axis_attest_in.tlast = axis_host_sink.tlast;
            // Attestation => RDMA
            axis_rdma_0_src.tvalid = axis_attest_out.tvalid;
            axis_attest_out.tready = axis_rdma_0_src.tready;
            axis_rdma_0_src.tdata = axis_attest_out.tdata;
            axis_rdma_0_src.tkeep = axis_attest_out.tkeep;
            axis_rdma_0_src.tid = axis_attest_out.tid;
            axis_rdma_0_src.tlast = axis_attest_out.tlast;
            // RDMA => verification
            axis_verify_in.tvalid = axis_rdma_0_sink.tvalid;
            axis_rdma_0_sink.tready = axis_verify_in.tready;
            axis_verify_in.tdata = axis_rdma_0_sink.tdata;
            axis_verify_in.tkeep = axis_rdma_0_sink.tkeep;
            axis_verify_in.tid = axis_rdma_0_sink.tid;
            axis_verify_in.tlast = axis_rdma_0_sink.tlast;
            // Verification => host
            axis_host_src.tvalid = axis_verify_out.tvalid;
            axis_verify_out.tready = axis_host_src.tready;
            axis_host_src.tdata = axis_verify_out.tdata;
            axis_host_src.tkeep = axis_verify_out.tkeep;
            axis_host_src.tid = axis_verify_out.tid;
            axis_host_src.tlast = axis_verify_out.tlast;
        end
    endcase
end

endmodule
