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
    metaIntf.m			        bpss_rd_req,
    metaIntf.m			        bpss_wr_req,
    metaIntf.s                  bpss_rd_done,
    metaIntf.s                  bpss_wr_done,

    // AXI4S HOST STREAMS
    AXI4SR.s                    axis_host_sink,
    AXI4SR.m                    axis_host_src,

    // RDMA QSFP0 CMD
    metaIntf.s			        rdma_0_rd_req,
    metaIntf.s 			        rdma_0_wr_req,

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
//always_comb axis_host_sink.tie_off_s();
//always_comb axis_host_src.tie_off_m();
	
//always_comb rdma_0_rd_req.tie_off_s();
//always_comb rdma_0_wr_req.tie_off_s();
//always_comb axis_rdma_0_sink.tie_off_s();
//always_comb axis_rdma_0_src.tie_off_m();

/* -- USER LOGIC -------------------------------------------------------- */
AXI4SR axis_rdma_0_sink2();
AXI4SR axis_host_sink2();

////////
// pcie to network
////////
abcd a1(

    // clock and reset
    .aclk(aclk),
    .areset(aresetn),
    
    .m_axis_host(axis_host_src),
    .s_axis_host(axis_rdma_0_sink2)
);

////////
// network to pcie
////////
abcd2 a2(

    // clock and reset
    .aclk(aclk),
    .areset(aresetn),
    
    .m_axis_host(axis_rdma_0_src),
    .s_axis_host(axis_host_sink2)
);


`include "perf_rdma_host_c0_0.svh"


endmodule