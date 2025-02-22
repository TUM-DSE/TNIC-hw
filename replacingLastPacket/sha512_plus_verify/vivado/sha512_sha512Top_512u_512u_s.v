// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Version: 2022.1
// Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module sha512_sha512Top_512u_512u_s (
        input_r_TDATA,
        output_r_TDATA,
        ap_clk,
        ap_rst,
        input_r_TVALID,
        input_r_TREADY,
        ap_start,
        output_r_TVALID,
        output_r_TREADY,
        ap_done,
        ap_ready,
        ap_idle,
        ap_continue
);


input  [583:0] input_r_TDATA;
output  [583:0] output_r_TDATA;
input   ap_clk;
input   ap_rst;
input   input_r_TVALID;
output   input_r_TREADY;
input   ap_start;
output   output_r_TVALID;
input   output_r_TREADY;
output   ap_done;
output   ap_ready;
output   ap_idle;
input   ap_continue;

wire    preProcessing_U0_ap_start;
wire    preProcessing_U0_start_full_n;
wire    preProcessing_U0_ap_done;
wire    preProcessing_U0_ap_continue;
wire    preProcessing_U0_ap_idle;
wire    preProcessing_U0_ap_ready;
wire    preProcessing_U0_start_out;
wire    preProcessing_U0_start_write;
wire    preProcessing_U0_input_r_TREADY;
wire   [1023:0] preProcessing_U0_blk_strm_din;
wire    preProcessing_U0_blk_strm_write;
wire   [0:0] preProcessing_U0_end_nblk_strm31_din;
wire    preProcessing_U0_end_nblk_strm31_write;
wire   [63:0] preProcessing_U0_tkeep_strm35_din;
wire    preProcessing_U0_tkeep_strm35_write;
wire   [5:0] preProcessing_U0_tid_strm36_din;
wire    preProcessing_U0_tid_strm36_write;
wire    dup_strm_128u_U0_ap_start;
wire    dup_strm_128u_U0_ap_done;
wire    dup_strm_128u_U0_ap_continue;
wire    dup_strm_128u_U0_ap_idle;
wire    dup_strm_128u_U0_ap_ready;
wire    dup_strm_128u_U0_end_nblk_strm31_read;
wire   [0:0] dup_strm_128u_U0_end_nblk_strm132_din;
wire    dup_strm_128u_U0_end_nblk_strm132_write;
wire   [0:0] dup_strm_128u_U0_end_nblk_strm233_din;
wire    dup_strm_128u_U0_end_nblk_strm233_write;
wire    generateMsgSchedule_U0_ap_start;
wire    generateMsgSchedule_U0_ap_done;
wire    generateMsgSchedule_U0_ap_continue;
wire    generateMsgSchedule_U0_ap_idle;
wire    generateMsgSchedule_U0_ap_ready;
wire    generateMsgSchedule_U0_blk_strm_read;
wire    generateMsgSchedule_U0_end_nblk_strm132_read;
wire   [63:0] generateMsgSchedule_U0_w_strm34_din;
wire    generateMsgSchedule_U0_w_strm34_write;
wire    SHA512Digest_64u_512u_U0_ap_start;
wire    SHA512Digest_64u_512u_U0_ap_done;
wire    SHA512Digest_64u_512u_U0_ap_continue;
wire    SHA512Digest_64u_512u_U0_ap_idle;
wire    SHA512Digest_64u_512u_U0_ap_ready;
wire    SHA512Digest_64u_512u_U0_w_strm34_read;
wire    SHA512Digest_64u_512u_U0_end_nblk_strm233_read;
wire    SHA512Digest_64u_512u_U0_tkeep_strm35_read;
wire    SHA512Digest_64u_512u_U0_tid_strm36_read;
wire   [583:0] SHA512Digest_64u_512u_U0_output_r_TDATA;
wire    SHA512Digest_64u_512u_U0_output_r_TVALID;
wire    blk_strm_full_n;
wire   [1023:0] blk_strm_dout;
wire   [5:0] blk_strm_num_data_valid;
wire   [5:0] blk_strm_fifo_cap;
wire    blk_strm_empty_n;
wire    end_nblk_strm_full_n;
wire   [0:0] end_nblk_strm_dout;
wire   [5:0] end_nblk_strm_num_data_valid;
wire   [5:0] end_nblk_strm_fifo_cap;
wire    end_nblk_strm_empty_n;
wire    tkeep_strm_full_n;
wire   [63:0] tkeep_strm_dout;
wire   [5:0] tkeep_strm_num_data_valid;
wire   [5:0] tkeep_strm_fifo_cap;
wire    tkeep_strm_empty_n;
wire    tid_strm_full_n;
wire   [5:0] tid_strm_dout;
wire   [5:0] tid_strm_num_data_valid;
wire   [5:0] tid_strm_fifo_cap;
wire    tid_strm_empty_n;
wire    end_nblk_strm1_full_n;
wire   [0:0] end_nblk_strm1_dout;
wire   [5:0] end_nblk_strm1_num_data_valid;
wire   [5:0] end_nblk_strm1_fifo_cap;
wire    end_nblk_strm1_empty_n;
wire    end_nblk_strm2_full_n;
wire   [0:0] end_nblk_strm2_dout;
wire   [5:0] end_nblk_strm2_num_data_valid;
wire   [5:0] end_nblk_strm2_fifo_cap;
wire    end_nblk_strm2_empty_n;
wire    w_strm_full_n;
wire   [63:0] w_strm_dout;
wire   [5:0] w_strm_num_data_valid;
wire   [5:0] w_strm_fifo_cap;
wire    w_strm_empty_n;
wire   [0:0] start_for_dup_strm_128u_U0_din;
wire    start_for_dup_strm_128u_U0_full_n;
wire   [0:0] start_for_dup_strm_128u_U0_dout;
wire    start_for_dup_strm_128u_U0_empty_n;
wire   [0:0] start_for_generateMsgSchedule_U0_din;
wire    start_for_generateMsgSchedule_U0_full_n;
wire   [0:0] start_for_generateMsgSchedule_U0_dout;
wire    start_for_generateMsgSchedule_U0_empty_n;
wire   [0:0] start_for_SHA512Digest_64u_512u_U0_din;
wire    start_for_SHA512Digest_64u_512u_U0_full_n;
wire   [0:0] start_for_SHA512Digest_64u_512u_U0_dout;
wire    start_for_SHA512Digest_64u_512u_U0_empty_n;

sha512_preProcessing preProcessing_U0(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(preProcessing_U0_ap_start),
    .start_full_n(preProcessing_U0_start_full_n),
    .ap_done(preProcessing_U0_ap_done),
    .ap_continue(preProcessing_U0_ap_continue),
    .ap_idle(preProcessing_U0_ap_idle),
    .ap_ready(preProcessing_U0_ap_ready),
    .start_out(preProcessing_U0_start_out),
    .start_write(preProcessing_U0_start_write),
    .input_r_TDATA(input_r_TDATA),
    .input_r_TVALID(input_r_TVALID),
    .input_r_TREADY(preProcessing_U0_input_r_TREADY),
    .blk_strm_din(preProcessing_U0_blk_strm_din),
    .blk_strm_num_data_valid(blk_strm_num_data_valid),
    .blk_strm_fifo_cap(blk_strm_fifo_cap),
    .blk_strm_full_n(blk_strm_full_n),
    .blk_strm_write(preProcessing_U0_blk_strm_write),
    .end_nblk_strm31_din(preProcessing_U0_end_nblk_strm31_din),
    .end_nblk_strm31_num_data_valid(end_nblk_strm_num_data_valid),
    .end_nblk_strm31_fifo_cap(end_nblk_strm_fifo_cap),
    .end_nblk_strm31_full_n(end_nblk_strm_full_n),
    .end_nblk_strm31_write(preProcessing_U0_end_nblk_strm31_write),
    .tkeep_strm35_din(preProcessing_U0_tkeep_strm35_din),
    .tkeep_strm35_num_data_valid(tkeep_strm_num_data_valid),
    .tkeep_strm35_fifo_cap(tkeep_strm_fifo_cap),
    .tkeep_strm35_full_n(tkeep_strm_full_n),
    .tkeep_strm35_write(preProcessing_U0_tkeep_strm35_write),
    .tid_strm36_din(preProcessing_U0_tid_strm36_din),
    .tid_strm36_num_data_valid(tid_strm_num_data_valid),
    .tid_strm36_fifo_cap(tid_strm_fifo_cap),
    .tid_strm36_full_n(tid_strm_full_n),
    .tid_strm36_write(preProcessing_U0_tid_strm36_write)
);

sha512_dup_strm_128u_s dup_strm_128u_U0(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(dup_strm_128u_U0_ap_start),
    .ap_done(dup_strm_128u_U0_ap_done),
    .ap_continue(dup_strm_128u_U0_ap_continue),
    .ap_idle(dup_strm_128u_U0_ap_idle),
    .ap_ready(dup_strm_128u_U0_ap_ready),
    .end_nblk_strm31_dout(end_nblk_strm_dout),
    .end_nblk_strm31_num_data_valid(end_nblk_strm_num_data_valid),
    .end_nblk_strm31_fifo_cap(end_nblk_strm_fifo_cap),
    .end_nblk_strm31_empty_n(end_nblk_strm_empty_n),
    .end_nblk_strm31_read(dup_strm_128u_U0_end_nblk_strm31_read),
    .end_nblk_strm132_din(dup_strm_128u_U0_end_nblk_strm132_din),
    .end_nblk_strm132_num_data_valid(end_nblk_strm1_num_data_valid),
    .end_nblk_strm132_fifo_cap(end_nblk_strm1_fifo_cap),
    .end_nblk_strm132_full_n(end_nblk_strm1_full_n),
    .end_nblk_strm132_write(dup_strm_128u_U0_end_nblk_strm132_write),
    .end_nblk_strm233_din(dup_strm_128u_U0_end_nblk_strm233_din),
    .end_nblk_strm233_num_data_valid(end_nblk_strm2_num_data_valid),
    .end_nblk_strm233_fifo_cap(end_nblk_strm2_fifo_cap),
    .end_nblk_strm233_full_n(end_nblk_strm2_full_n),
    .end_nblk_strm233_write(dup_strm_128u_U0_end_nblk_strm233_write)
);

sha512_generateMsgSchedule generateMsgSchedule_U0(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(generateMsgSchedule_U0_ap_start),
    .ap_done(generateMsgSchedule_U0_ap_done),
    .ap_continue(generateMsgSchedule_U0_ap_continue),
    .ap_idle(generateMsgSchedule_U0_ap_idle),
    .ap_ready(generateMsgSchedule_U0_ap_ready),
    .blk_strm_dout(blk_strm_dout),
    .blk_strm_num_data_valid(blk_strm_num_data_valid),
    .blk_strm_fifo_cap(blk_strm_fifo_cap),
    .blk_strm_empty_n(blk_strm_empty_n),
    .blk_strm_read(generateMsgSchedule_U0_blk_strm_read),
    .end_nblk_strm132_dout(end_nblk_strm1_dout),
    .end_nblk_strm132_num_data_valid(end_nblk_strm1_num_data_valid),
    .end_nblk_strm132_fifo_cap(end_nblk_strm1_fifo_cap),
    .end_nblk_strm132_empty_n(end_nblk_strm1_empty_n),
    .end_nblk_strm132_read(generateMsgSchedule_U0_end_nblk_strm132_read),
    .w_strm34_din(generateMsgSchedule_U0_w_strm34_din),
    .w_strm34_num_data_valid(w_strm_num_data_valid),
    .w_strm34_fifo_cap(w_strm_fifo_cap),
    .w_strm34_full_n(w_strm_full_n),
    .w_strm34_write(generateMsgSchedule_U0_w_strm34_write)
);

sha512_SHA512Digest_64u_512u_s SHA512Digest_64u_512u_U0(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(SHA512Digest_64u_512u_U0_ap_start),
    .ap_done(SHA512Digest_64u_512u_U0_ap_done),
    .ap_continue(SHA512Digest_64u_512u_U0_ap_continue),
    .ap_idle(SHA512Digest_64u_512u_U0_ap_idle),
    .ap_ready(SHA512Digest_64u_512u_U0_ap_ready),
    .w_strm34_dout(w_strm_dout),
    .w_strm34_num_data_valid(w_strm_num_data_valid),
    .w_strm34_fifo_cap(w_strm_fifo_cap),
    .w_strm34_empty_n(w_strm_empty_n),
    .w_strm34_read(SHA512Digest_64u_512u_U0_w_strm34_read),
    .end_nblk_strm233_dout(end_nblk_strm2_dout),
    .end_nblk_strm233_num_data_valid(end_nblk_strm2_num_data_valid),
    .end_nblk_strm233_fifo_cap(end_nblk_strm2_fifo_cap),
    .end_nblk_strm233_empty_n(end_nblk_strm2_empty_n),
    .end_nblk_strm233_read(SHA512Digest_64u_512u_U0_end_nblk_strm233_read),
    .tkeep_strm35_dout(tkeep_strm_dout),
    .tkeep_strm35_num_data_valid(tkeep_strm_num_data_valid),
    .tkeep_strm35_fifo_cap(tkeep_strm_fifo_cap),
    .tkeep_strm35_empty_n(tkeep_strm_empty_n),
    .tkeep_strm35_read(SHA512Digest_64u_512u_U0_tkeep_strm35_read),
    .tid_strm36_dout(tid_strm_dout),
    .tid_strm36_num_data_valid(tid_strm_num_data_valid),
    .tid_strm36_fifo_cap(tid_strm_fifo_cap),
    .tid_strm36_empty_n(tid_strm_empty_n),
    .tid_strm36_read(SHA512Digest_64u_512u_U0_tid_strm36_read),
    .output_r_TDATA(SHA512Digest_64u_512u_U0_output_r_TDATA),
    .output_r_TVALID(SHA512Digest_64u_512u_U0_output_r_TVALID),
    .output_r_TREADY(output_r_TREADY)
);

sha512_fifo_w1024_d32_D blk_strm_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(preProcessing_U0_blk_strm_din),
    .if_full_n(blk_strm_full_n),
    .if_write(preProcessing_U0_blk_strm_write),
    .if_dout(blk_strm_dout),
    .if_num_data_valid(blk_strm_num_data_valid),
    .if_fifo_cap(blk_strm_fifo_cap),
    .if_empty_n(blk_strm_empty_n),
    .if_read(generateMsgSchedule_U0_blk_strm_read)
);

sha512_fifo_w1_d32_D end_nblk_strm_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(preProcessing_U0_end_nblk_strm31_din),
    .if_full_n(end_nblk_strm_full_n),
    .if_write(preProcessing_U0_end_nblk_strm31_write),
    .if_dout(end_nblk_strm_dout),
    .if_num_data_valid(end_nblk_strm_num_data_valid),
    .if_fifo_cap(end_nblk_strm_fifo_cap),
    .if_empty_n(end_nblk_strm_empty_n),
    .if_read(dup_strm_128u_U0_end_nblk_strm31_read)
);

sha512_fifo_w64_d32_D tkeep_strm_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(preProcessing_U0_tkeep_strm35_din),
    .if_full_n(tkeep_strm_full_n),
    .if_write(preProcessing_U0_tkeep_strm35_write),
    .if_dout(tkeep_strm_dout),
    .if_num_data_valid(tkeep_strm_num_data_valid),
    .if_fifo_cap(tkeep_strm_fifo_cap),
    .if_empty_n(tkeep_strm_empty_n),
    .if_read(SHA512Digest_64u_512u_U0_tkeep_strm35_read)
);

sha512_fifo_w6_d32_D tid_strm_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(preProcessing_U0_tid_strm36_din),
    .if_full_n(tid_strm_full_n),
    .if_write(preProcessing_U0_tid_strm36_write),
    .if_dout(tid_strm_dout),
    .if_num_data_valid(tid_strm_num_data_valid),
    .if_fifo_cap(tid_strm_fifo_cap),
    .if_empty_n(tid_strm_empty_n),
    .if_read(SHA512Digest_64u_512u_U0_tid_strm36_read)
);

sha512_fifo_w1_d32_D end_nblk_strm1_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(dup_strm_128u_U0_end_nblk_strm132_din),
    .if_full_n(end_nblk_strm1_full_n),
    .if_write(dup_strm_128u_U0_end_nblk_strm132_write),
    .if_dout(end_nblk_strm1_dout),
    .if_num_data_valid(end_nblk_strm1_num_data_valid),
    .if_fifo_cap(end_nblk_strm1_fifo_cap),
    .if_empty_n(end_nblk_strm1_empty_n),
    .if_read(generateMsgSchedule_U0_end_nblk_strm132_read)
);

sha512_fifo_w1_d32_D end_nblk_strm2_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(dup_strm_128u_U0_end_nblk_strm233_din),
    .if_full_n(end_nblk_strm2_full_n),
    .if_write(dup_strm_128u_U0_end_nblk_strm233_write),
    .if_dout(end_nblk_strm2_dout),
    .if_num_data_valid(end_nblk_strm2_num_data_valid),
    .if_fifo_cap(end_nblk_strm2_fifo_cap),
    .if_empty_n(end_nblk_strm2_empty_n),
    .if_read(SHA512Digest_64u_512u_U0_end_nblk_strm233_read)
);

sha512_fifo_w64_d32_D w_strm_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(generateMsgSchedule_U0_w_strm34_din),
    .if_full_n(w_strm_full_n),
    .if_write(generateMsgSchedule_U0_w_strm34_write),
    .if_dout(w_strm_dout),
    .if_num_data_valid(w_strm_num_data_valid),
    .if_fifo_cap(w_strm_fifo_cap),
    .if_empty_n(w_strm_empty_n),
    .if_read(SHA512Digest_64u_512u_U0_w_strm34_read)
);

sha512_start_for_dup_strm_128u_U0 start_for_dup_strm_128u_U0_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(start_for_dup_strm_128u_U0_din),
    .if_full_n(start_for_dup_strm_128u_U0_full_n),
    .if_write(preProcessing_U0_start_write),
    .if_dout(start_for_dup_strm_128u_U0_dout),
    .if_empty_n(start_for_dup_strm_128u_U0_empty_n),
    .if_read(dup_strm_128u_U0_ap_ready)
);

sha512_start_for_generateMsgSchedule_U0 start_for_generateMsgSchedule_U0_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(start_for_generateMsgSchedule_U0_din),
    .if_full_n(start_for_generateMsgSchedule_U0_full_n),
    .if_write(preProcessing_U0_start_write),
    .if_dout(start_for_generateMsgSchedule_U0_dout),
    .if_empty_n(start_for_generateMsgSchedule_U0_empty_n),
    .if_read(generateMsgSchedule_U0_ap_ready)
);

sha512_start_for_SHA512Digest_64u_512u_U0 start_for_SHA512Digest_64u_512u_U0_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(start_for_SHA512Digest_64u_512u_U0_din),
    .if_full_n(start_for_SHA512Digest_64u_512u_U0_full_n),
    .if_write(preProcessing_U0_start_write),
    .if_dout(start_for_SHA512Digest_64u_512u_U0_dout),
    .if_empty_n(start_for_SHA512Digest_64u_512u_U0_empty_n),
    .if_read(SHA512Digest_64u_512u_U0_ap_ready)
);

assign SHA512Digest_64u_512u_U0_ap_continue = ap_continue;

assign SHA512Digest_64u_512u_U0_ap_start = start_for_SHA512Digest_64u_512u_U0_empty_n;

assign ap_done = SHA512Digest_64u_512u_U0_ap_done;

assign ap_idle = (preProcessing_U0_ap_idle & generateMsgSchedule_U0_ap_idle & dup_strm_128u_U0_ap_idle & SHA512Digest_64u_512u_U0_ap_idle);

assign ap_ready = preProcessing_U0_ap_ready;

assign dup_strm_128u_U0_ap_continue = 1'b1;

assign dup_strm_128u_U0_ap_start = start_for_dup_strm_128u_U0_empty_n;

assign generateMsgSchedule_U0_ap_continue = 1'b1;

assign generateMsgSchedule_U0_ap_start = start_for_generateMsgSchedule_U0_empty_n;

assign input_r_TREADY = preProcessing_U0_input_r_TREADY;

assign output_r_TDATA = SHA512Digest_64u_512u_U0_output_r_TDATA;

assign output_r_TVALID = SHA512Digest_64u_512u_U0_output_r_TVALID;

assign preProcessing_U0_ap_continue = 1'b1;

assign preProcessing_U0_ap_start = ap_start;

assign preProcessing_U0_start_full_n = (start_for_generateMsgSchedule_U0_full_n & start_for_dup_strm_128u_U0_full_n & start_for_SHA512Digest_64u_512u_U0_full_n);

assign start_for_SHA512Digest_64u_512u_U0_din = 1'b1;

assign start_for_dup_strm_128u_U0_din = 1'b1;

assign start_for_generateMsgSchedule_U0_din = 1'b1;

endmodule //sha512_sha512Top_512u_512u_s
