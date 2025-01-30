`timescale 1ns / 1ps

import lynxTypes::*;

module abcd2 #( parameter integer AXIS_TDATA_WIDTH = 512) (

    // clock and reset

    input wire aclk,
    input wire areset,
    AXI4SR.s                                 s_axis_host,
    AXI4SR.m                                 m_axis_host
);
// user logic
AXI4SR qq1();
AXI4SR qq2();

axisr_data_fifo_512 fifo1 (
    .s_axis_aresetn(areset),
    .s_axis_aclk(aclk),
    .s_axis_tvalid(s_axis_host.tvalid),
    .s_axis_tready(s_axis_host.tready),
    .s_axis_tdata(s_axis_host.tdata),
    .s_axis_tkeep(s_axis_host.tkeep),
    .s_axis_tid  (s_axis_host.tid),
    .s_axis_tlast(s_axis_host.tlast),

    
    .m_axis_tvalid(qq1.tvalid),
    .m_axis_tready(qq1.tready),
    .m_axis_tdata(qq1.tdata),
    .m_axis_tkeep(qq1.tkeep),
    .m_axis_tid  (qq1.tid),
    .m_axis_tlast(qq1.tlast)
);


//logic a;
//decaesar c1(.ap_clk(aclk),
//        .ap_rst_n(areset),
//        .input_r_TDATA({1'b0,qq1.tlast, qq1.tid, qq1.tkeep, qq1.tdata}),
//        .input_r_TVALID(qq1.tvalid),
//        .input_r_TREADY(qq1.tready),
//        .output_r_TREADY(qq2.tready),
//        .output_r_TDATA({a, qq2.tlast, qq2.tid, qq2.tkeep, qq2.tdata}),
//        .output_r_TVALID(qq2.tvalid));


decaesar c1(
        .clock(aclk),
        .reset(areset),

        .inp_data(qq1.tdata),
        .inp_valid(qq1.tvalid),
        .inp_ready(qq1.tready),
        .inp_keep(qq1.tkeep),
        .inp_id(qq1.tid),
        .inp_last(qq1.tlast),

        .out(qq2.tdata),
        .out_valid(qq2.tvalid),
        .out_ready(qq2.tready),
        .out_keep(qq2.tkeep),
        .out_id(qq2.tid),
        .out_last(qq2.tlast));


axisr_data_fifo_512 fifo2 (
    .s_axis_aresetn(areset),
    .s_axis_aclk(aclk),
    .s_axis_tvalid(qq2.tvalid),
    .s_axis_tready(qq2.tready),
    .s_axis_tdata(qq2.tdata),
    .s_axis_tkeep(qq2.tkeep),
    .s_axis_tid  (qq2.tid),
    .s_axis_tlast(qq2.tlast),

    
    .m_axis_tvalid(m_axis_host.tvalid),
    .m_axis_tready(m_axis_host.tready),
    .m_axis_tdata(m_axis_host.tdata),
    .m_axis_tkeep(m_axis_host.tkeep),
    .m_axis_tid  (m_axis_host.tid),
    .m_axis_tlast(m_axis_host.tlast)
);


// user logic ends


endmodule
