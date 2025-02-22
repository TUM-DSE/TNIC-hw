// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Version: 2022.1
// Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module sha512_dup_strm_128u_Pipeline_LOOP_DUP_STREAM (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        end_nblk_strm31_dout,
        end_nblk_strm31_num_data_valid,
        end_nblk_strm31_fifo_cap,
        end_nblk_strm31_empty_n,
        end_nblk_strm31_read,
        end_nblk_strm132_din,
        end_nblk_strm132_num_data_valid,
        end_nblk_strm132_fifo_cap,
        end_nblk_strm132_full_n,
        end_nblk_strm132_write,
        end_nblk_strm233_din,
        end_nblk_strm233_num_data_valid,
        end_nblk_strm233_fifo_cap,
        end_nblk_strm233_full_n,
        end_nblk_strm233_write,
        tmp
);

parameter    ap_ST_fsm_pp0_stage0 = 1'd1;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [0:0] end_nblk_strm31_dout;
input  [5:0] end_nblk_strm31_num_data_valid;
input  [5:0] end_nblk_strm31_fifo_cap;
input   end_nblk_strm31_empty_n;
output   end_nblk_strm31_read;
output  [0:0] end_nblk_strm132_din;
input  [5:0] end_nblk_strm132_num_data_valid;
input  [5:0] end_nblk_strm132_fifo_cap;
input   end_nblk_strm132_full_n;
output   end_nblk_strm132_write;
output  [0:0] end_nblk_strm233_din;
input  [5:0] end_nblk_strm233_num_data_valid;
input  [5:0] end_nblk_strm233_fifo_cap;
input   end_nblk_strm233_full_n;
output   end_nblk_strm233_write;
input  [0:0] tmp;

reg ap_idle;
reg end_nblk_strm31_read;
reg end_nblk_strm132_write;
reg end_nblk_strm233_write;

(* fsm_encoding = "none" *) reg   [0:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_idle_pp0;
reg   [0:0] ap_phi_mux_e_phi_fu_77_p4;
reg    ap_block_state1_pp0_stage0_iter0;
reg   [0:0] e_reg_74;
reg    ap_block_state2_pp0_stage0_iter1;
reg    ap_block_pp0_stage0_subdone;
reg    ap_condition_exit_pp0_iter0_stage0;
wire    ap_loop_exit_ready;
reg    ap_ready_int;
reg    end_nblk_strm132_blk_n;
wire    ap_block_pp0_stage0;
reg    end_nblk_strm233_blk_n;
reg    end_nblk_strm31_blk_n;
reg   [0:0] tmp_11_reg_85;
reg    ap_block_pp0_stage0_11001;
wire    ap_loop_init;
reg    ap_block_pp0_stage0_01001;
reg    ap_done_reg;
wire    ap_continue_int;
reg    ap_done_int;
reg   [0:0] ap_NS_fsm;
wire    ap_enable_pp0;
wire    ap_start_int;
reg    ap_condition_142;
reg    ap_condition_147;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 1'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_done_reg = 1'b0;
end

sha512_flow_control_loop_pipe_sequential_init flow_control_loop_pipe_sequential_init_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(ap_start),
    .ap_ready(ap_ready),
    .ap_done(ap_done),
    .ap_start_int(ap_start_int),
    .ap_loop_init(ap_loop_init),
    .ap_ready_int(ap_ready_int),
    .ap_loop_exit_ready(ap_condition_exit_pp0_iter0_stage0),
    .ap_loop_exit_done(ap_done_int),
    .ap_continue_int(ap_continue_int),
    .ap_done_int(ap_done_int)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue_int == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if (((ap_loop_exit_ready == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if ((1'b1 == ap_condition_exit_pp0_iter0_stage0)) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_enable_reg_pp0_iter1 <= ap_start_int;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
        if ((1'b1 == ap_condition_147)) begin
            e_reg_74 <= tmp_11_reg_85;
        end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_loop_init == 1'b1))) begin
            e_reg_74 <= tmp;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_phi_mux_e_phi_fu_77_p4 == 1'd0) & (ap_start_int == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        tmp_11_reg_85 <= end_nblk_strm31_dout;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_phi_mux_e_phi_fu_77_p4 == 1'd1) & (ap_start_int == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_condition_exit_pp0_iter0_stage0 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter0_stage0 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_loop_exit_ready == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_done_int = 1'b1;
    end else begin
        ap_done_int = ap_done_reg;
    end
end

always @ (*) begin
    if (((ap_idle_pp0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_start_int == 1'b0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
        if ((1'b1 == ap_condition_142)) begin
            ap_phi_mux_e_phi_fu_77_p4 = tmp_11_reg_85;
        end else if ((ap_loop_init == 1'b1)) begin
            ap_phi_mux_e_phi_fu_77_p4 = tmp;
        end else begin
            ap_phi_mux_e_phi_fu_77_p4 = tmp_11_reg_85;
        end
    end else begin
        ap_phi_mux_e_phi_fu_77_p4 = tmp_11_reg_85;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_start_int == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (e_reg_74 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        end_nblk_strm132_blk_n = end_nblk_strm132_full_n;
    end else begin
        end_nblk_strm132_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (e_reg_74 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        end_nblk_strm132_write = 1'b1;
    end else begin
        end_nblk_strm132_write = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (e_reg_74 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        end_nblk_strm233_blk_n = end_nblk_strm233_full_n;
    end else begin
        end_nblk_strm233_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (e_reg_74 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        end_nblk_strm233_write = 1'b1;
    end else begin
        end_nblk_strm233_write = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (ap_phi_mux_e_phi_fu_77_p4 == 1'd0) & (ap_start_int == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        end_nblk_strm31_blk_n = end_nblk_strm31_empty_n;
    end else begin
        end_nblk_strm31_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_phi_mux_e_phi_fu_77_p4 == 1'd0) & (ap_start_int == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        end_nblk_strm31_read = 1'b1;
    end else begin
        end_nblk_strm31_read = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_pp0_stage0 : begin
            ap_NS_fsm = ap_ST_fsm_pp0_stage0;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage0_01001 = (((ap_enable_reg_pp0_iter1 == 1'b1) & (((end_nblk_strm233_full_n == 1'b0) & (e_reg_74 == 1'd0)) | ((e_reg_74 == 1'd0) & (end_nblk_strm132_full_n == 1'b0)))) | ((ap_phi_mux_e_phi_fu_77_p4 == 1'd0) & (end_nblk_strm31_empty_n == 1'b0) & (ap_start_int == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_11001 = (((ap_enable_reg_pp0_iter1 == 1'b1) & (((end_nblk_strm233_full_n == 1'b0) & (e_reg_74 == 1'd0)) | ((e_reg_74 == 1'd0) & (end_nblk_strm132_full_n == 1'b0)))) | ((ap_phi_mux_e_phi_fu_77_p4 == 1'd0) & (end_nblk_strm31_empty_n == 1'b0) & (ap_start_int == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_subdone = (((ap_enable_reg_pp0_iter1 == 1'b1) & (((end_nblk_strm233_full_n == 1'b0) & (e_reg_74 == 1'd0)) | ((e_reg_74 == 1'd0) & (end_nblk_strm132_full_n == 1'b0)))) | ((ap_phi_mux_e_phi_fu_77_p4 == 1'd0) & (end_nblk_strm31_empty_n == 1'b0) & (ap_start_int == 1'b1)));
end

always @ (*) begin
    ap_block_state1_pp0_stage0_iter0 = ((ap_phi_mux_e_phi_fu_77_p4 == 1'd0) & (end_nblk_strm31_empty_n == 1'b0));
end

always @ (*) begin
    ap_block_state2_pp0_stage0_iter1 = (((end_nblk_strm233_full_n == 1'b0) & (e_reg_74 == 1'd0)) | ((e_reg_74 == 1'd0) & (end_nblk_strm132_full_n == 1'b0)));
end

always @ (*) begin
    ap_condition_142 = ((1'b0 == ap_block_pp0_stage0) & (e_reg_74 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

always @ (*) begin
    ap_condition_147 = ((1'b0 == ap_block_pp0_stage0_11001) & (e_reg_74 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_enable_reg_pp0_iter0 = ap_start_int;

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter0_stage0;

assign end_nblk_strm132_din = 1'd0;

assign end_nblk_strm233_din = 1'd0;

endmodule //sha512_dup_strm_128u_Pipeline_LOOP_DUP_STREAM
