// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Version: 2022.1
// Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module sha512_verify_dup_strm_128u_s (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_continue,
        ap_idle,
        ap_ready,
        end_nblk_strm3_dout,
        end_nblk_strm3_num_data_valid,
        end_nblk_strm3_fifo_cap,
        end_nblk_strm3_empty_n,
        end_nblk_strm3_read,
        end_nblk_strm14_din,
        end_nblk_strm14_num_data_valid,
        end_nblk_strm14_fifo_cap,
        end_nblk_strm14_full_n,
        end_nblk_strm14_write,
        end_nblk_strm25_din,
        end_nblk_strm25_num_data_valid,
        end_nblk_strm25_fifo_cap,
        end_nblk_strm25_full_n,
        end_nblk_strm25_write
);

parameter    ap_ST_fsm_state1 = 4'd1;
parameter    ap_ST_fsm_state2 = 4'd2;
parameter    ap_ST_fsm_state3 = 4'd4;
parameter    ap_ST_fsm_state4 = 4'd8;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
input   ap_continue;
output   ap_idle;
output   ap_ready;
input  [0:0] end_nblk_strm3_dout;
input  [5:0] end_nblk_strm3_num_data_valid;
input  [5:0] end_nblk_strm3_fifo_cap;
input   end_nblk_strm3_empty_n;
output   end_nblk_strm3_read;
output  [0:0] end_nblk_strm14_din;
input  [5:0] end_nblk_strm14_num_data_valid;
input  [5:0] end_nblk_strm14_fifo_cap;
input   end_nblk_strm14_full_n;
output   end_nblk_strm14_write;
output  [0:0] end_nblk_strm25_din;
input  [5:0] end_nblk_strm25_num_data_valid;
input  [5:0] end_nblk_strm25_fifo_cap;
input   end_nblk_strm25_full_n;
output   end_nblk_strm25_write;

reg ap_done;
reg ap_idle;
reg ap_ready;
reg end_nblk_strm3_read;
reg[0:0] end_nblk_strm14_din;
reg end_nblk_strm14_write;
reg[0:0] end_nblk_strm25_din;
reg end_nblk_strm25_write;

reg    ap_done_reg;
(* fsm_encoding = "none" *) reg   [3:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    end_nblk_strm3_blk_n;
reg    end_nblk_strm14_blk_n;
wire    ap_CS_fsm_state4;
reg    end_nblk_strm25_blk_n;
reg   [0:0] tmp_reg_67;
wire    grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_start;
wire    grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_done;
wire    grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_idle;
wire    grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_ready;
wire    grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm3_read;
wire   [0:0] grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm14_din;
wire    grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm14_write;
wire   [0:0] grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm25_din;
wire    grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm25_write;
reg    grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_start_reg;
wire    ap_CS_fsm_state2;
wire    ap_CS_fsm_state3;
reg    ap_block_state1;
reg    ap_block_state4;
reg   [3:0] ap_NS_fsm;
reg    ap_ST_fsm_state1_blk;
wire    ap_ST_fsm_state2_blk;
reg    ap_ST_fsm_state3_blk;
reg    ap_ST_fsm_state4_blk;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_done_reg = 1'b0;
#0 ap_CS_fsm = 4'd1;
#0 grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_start_reg = 1'b0;
end

sha512_verify_dup_strm_128u_Pipeline_LOOP_DUP_STREAM grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_start),
    .ap_done(grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_done),
    .ap_idle(grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_idle),
    .ap_ready(grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_ready),
    .end_nblk_strm3_dout(end_nblk_strm3_dout),
    .end_nblk_strm3_num_data_valid(6'd0),
    .end_nblk_strm3_fifo_cap(6'd0),
    .end_nblk_strm3_empty_n(end_nblk_strm3_empty_n),
    .end_nblk_strm3_read(grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm3_read),
    .end_nblk_strm14_din(grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm14_din),
    .end_nblk_strm14_num_data_valid(6'd0),
    .end_nblk_strm14_fifo_cap(6'd0),
    .end_nblk_strm14_full_n(end_nblk_strm14_full_n),
    .end_nblk_strm14_write(grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm14_write),
    .end_nblk_strm25_din(grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm25_din),
    .end_nblk_strm25_num_data_valid(6'd0),
    .end_nblk_strm25_fifo_cap(6'd0),
    .end_nblk_strm25_full_n(end_nblk_strm25_full_n),
    .end_nblk_strm25_write(grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm25_write),
    .tmp(tmp_reg_67)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if ((~((end_nblk_strm25_full_n == 1'b0) | (end_nblk_strm14_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state4))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_start_reg <= 1'b0;
    end else begin
        if ((1'b1 == ap_CS_fsm_state2)) begin
            grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_start_reg <= 1'b1;
        end else if ((grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_ready == 1'b1)) begin
            grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_start_reg <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state1)) begin
        tmp_reg_67 <= end_nblk_strm3_dout;
    end
end

always @ (*) begin
    if (((ap_start == 1'b0) | (end_nblk_strm3_empty_n == 1'b0) | (ap_done_reg == 1'b1))) begin
        ap_ST_fsm_state1_blk = 1'b1;
    end else begin
        ap_ST_fsm_state1_blk = 1'b0;
    end
end

assign ap_ST_fsm_state2_blk = 1'b0;

always @ (*) begin
    if ((grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_done == 1'b0)) begin
        ap_ST_fsm_state3_blk = 1'b1;
    end else begin
        ap_ST_fsm_state3_blk = 1'b0;
    end
end

always @ (*) begin
    if (((end_nblk_strm25_full_n == 1'b0) | (end_nblk_strm14_full_n == 1'b0))) begin
        ap_ST_fsm_state4_blk = 1'b1;
    end else begin
        ap_ST_fsm_state4_blk = 1'b0;
    end
end

always @ (*) begin
    if ((~((end_nblk_strm25_full_n == 1'b0) | (end_nblk_strm14_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state4))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = ap_done_reg;
    end
end

always @ (*) begin
    if (((ap_start == 1'b0) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if ((~((end_nblk_strm25_full_n == 1'b0) | (end_nblk_strm14_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state4))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        end_nblk_strm14_blk_n = end_nblk_strm14_full_n;
    end else begin
        end_nblk_strm14_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((end_nblk_strm25_full_n == 1'b0) | (end_nblk_strm14_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state4))) begin
        end_nblk_strm14_din = 1'd1;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        end_nblk_strm14_din = grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm14_din;
    end else begin
        end_nblk_strm14_din = grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm14_din;
    end
end

always @ (*) begin
    if ((~((end_nblk_strm25_full_n == 1'b0) | (end_nblk_strm14_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state4))) begin
        end_nblk_strm14_write = 1'b1;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        end_nblk_strm14_write = grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm14_write;
    end else begin
        end_nblk_strm14_write = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        end_nblk_strm25_blk_n = end_nblk_strm25_full_n;
    end else begin
        end_nblk_strm25_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((end_nblk_strm25_full_n == 1'b0) | (end_nblk_strm14_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state4))) begin
        end_nblk_strm25_din = 1'd1;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        end_nblk_strm25_din = grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm25_din;
    end else begin
        end_nblk_strm25_din = grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm25_din;
    end
end

always @ (*) begin
    if ((~((end_nblk_strm25_full_n == 1'b0) | (end_nblk_strm14_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state4))) begin
        end_nblk_strm25_write = 1'b1;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        end_nblk_strm25_write = grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm25_write;
    end else begin
        end_nblk_strm25_write = 1'b0;
    end
end

always @ (*) begin
    if ((~((ap_start == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
        end_nblk_strm3_blk_n = end_nblk_strm3_empty_n;
    end else begin
        end_nblk_strm3_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((ap_start == 1'b0) | (end_nblk_strm3_empty_n == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
        end_nblk_strm3_read = 1'b1;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        end_nblk_strm3_read = grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_end_nblk_strm3_read;
    end else begin
        end_nblk_strm3_read = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if ((~((ap_start == 1'b0) | (end_nblk_strm3_empty_n == 1'b0) | (ap_done_reg == 1'b1)) & (1'b1 == ap_CS_fsm_state1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            ap_NS_fsm = ap_ST_fsm_state3;
        end
        ap_ST_fsm_state3 : begin
            if (((grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_done == 1'b1) & (1'b1 == ap_CS_fsm_state3))) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state4 : begin
            if ((~((end_nblk_strm25_full_n == 1'b0) | (end_nblk_strm14_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state4))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

always @ (*) begin
    ap_block_state1 = ((ap_start == 1'b0) | (end_nblk_strm3_empty_n == 1'b0) | (ap_done_reg == 1'b1));
end

always @ (*) begin
    ap_block_state4 = ((end_nblk_strm25_full_n == 1'b0) | (end_nblk_strm14_full_n == 1'b0));
end

assign grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_start = grp_dup_strm_128u_Pipeline_LOOP_DUP_STREAM_fu_56_ap_start_reg;

endmodule //sha512_verify_dup_strm_128u_s
