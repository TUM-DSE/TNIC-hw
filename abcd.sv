`timescale 1ns / 1ps

import lynxTypes::*;

module abcd #( parameter integer AXIS_TDATA_WIDTH = 512) (

    // clock and reset

    input wire aclk,
    input wire areset,
    AXI4SR.s                                 s_axis_host,
    AXI4SR.m                                 m_axis_host
);
// user logic
AXI4SR qq();

logic a;
caesar c1(.ap_clk(aclk),
        .ap_rst_n(areset),
        .input_r_TDATA({1'b0,s_axis_host.tlast, s_axis_host.tid, s_axis_host.tkeep, s_axis_host.tdata}),
        .input_r_TVALID(s_axis_host.tvalid),
        .input_r_TREADY(s_axis_host.tready),
        .output_r_TREADY(qq.tready),
        .output_r_TDATA({a, qq.tlast, qq.tid, qq.tkeep, qq.tdata}),
        .output_r_TVALID(qq.tvalid));

assign m_axis_host.tdata      = qq.tdata;
assign m_axis_host.tkeep      = qq.tkeep;
assign m_axis_host.tlast      = qq.tlast;
assign m_axis_host.tvalid     = qq.tvalid;
assign qq.tready     = m_axis_host.tready;
assign m_axis_host.tid  		= qq.tid; 	



// user logic ends


endmodule
