`timescale 1ns / 1ps

import lynxTypes::*;

module abcd #(
    parameter integer AXIS_TDATA_WIDTH = 512
) (
    input wire aclk,
    input wire areset,
    AXI4SR.s   s_axis_host,
    AXI4SR.m   m_axis_host
);

AXI4SR qq1();
AXI4SR metadata();
AXI4SR qq2();
AXI4SR qq2DATA();
AXI4SR qq2CHECKSUM();
AXI4SR qq2CHECKSUMout();
AXI4SR qq2CHECKSUMout2();

axisr_data_fifo_512 fifo1 (
    .s_axis_aclk   (aclk),
    .s_axis_aresetn(areset),

    .s_axis_tvalid(s_axis_host.tvalid),
    .s_axis_tready(s_axis_host.tready),
    .s_axis_tdata (s_axis_host.tdata),
    .s_axis_tkeep (s_axis_host.tkeep),
    .s_axis_tid   (s_axis_host.tid),
    .s_axis_tlast (s_axis_host.tlast),

    .m_axis_tvalid(qq1.tvalid),
    .m_axis_tready(qq1.tready),
    .m_axis_tdata (qq1.tdata),
    .m_axis_tkeep (qq1.tkeep),
    .m_axis_tid   (qq1.tid),
    .m_axis_tlast (qq1.tlast)
);

add_metadata #(
    .FPGA_ID(64'hC0FFEE0123456789),
    .CONNECTION_ID(64'hDEADBEEF98765432),
    .INITIAL_COUNTER_VALUE('0)
) add_metadata_inst (
    .s_axis_aclk   (aclk),
    .s_axis_aresetn(areset),

    .s_axis_tvalid(qq1.tvalid),
    .s_axis_tready(qq1.tready),
    .s_axis_tdata (qq1.tdata),
    .s_axis_tkeep (qq1.tkeep),
    .s_axis_tid   (qq1.tid),
    .s_axis_tlast (qq1.tlast),

    .m_axis_tvalid(metadata.tvalid),
    .m_axis_tready(metadata.tready),
    .m_axis_tdata (metadata.tdata),
    .m_axis_tkeep (metadata.tkeep),
    .m_axis_tid   (metadata.tid),
    .m_axis_tlast (metadata.tlast)
);

inputFIFODuplicate dupFifo(
    .clock(aclk),
    .reset(areset),

    .input_axis_tvalid(metadata.tvalid),
    .input_axis_tready(metadata.tready),
    .input_axis_tdata (metadata.tdata),
    .input_axis_tkeep (metadata.tkeep),
    .input_axis_tid   (metadata.tid),
    .input_axis_tlast (metadata.tlast),

    .output1_axis_tvalid(qq2DATA.tvalid),
    .output1_axis_tready(qq2DATA.tready),
    .output1_axis_tdata (qq2DATA.tdata),
    .output1_axis_tkeep (qq2DATA.tkeep),
    .output1_axis_tid   (qq2DATA.tid),
    .output1_axis_tlast (qq2DATA.tlast),

    .output2_axis_tvalid(qq2CHECKSUM.tvalid),
    .output2_axis_tready(qq2CHECKSUM.tready),
    .output2_axis_tdata (qq2CHECKSUM.tdata),
    .output2_axis_tkeep (qq2CHECKSUM.tkeep),
    .output2_axis_tid   (qq2CHECKSUM.tid),
    .output2_axis_tlast (qq2CHECKSUM.tlast)
);

logic a;

hmac c1 (
    .ap_clk  (aclk),
    .ap_rst_n(areset),

    .input_r_TDATA ({1'b0, qq2CHECKSUM.tlast, qq2CHECKSUM.tid, qq2CHECKSUM.tkeep, qq2CHECKSUM.tdata}),
    .input_r_TVALID(qq2CHECKSUM.tvalid),
    .input_r_TREADY(qq2CHECKSUM.tready),

    .output_r_TREADY(qq2CHECKSUMout.tready),
    .output_r_TDATA ({a, qq2CHECKSUMout.tlast, qq2CHECKSUMout.tid, qq2CHECKSUMout.tkeep, qq2CHECKSUMout.tdata}),
    .output_r_TVALID(qq2CHECKSUMout.tvalid)
);

axisr_data_fifo_512 fifo2 (
    .s_axis_aclk   (aclk),
    .s_axis_aresetn(areset),

    .s_axis_tvalid(qq2CHECKSUMout.tvalid),
    .s_axis_tready(qq2CHECKSUMout.tready),
    .s_axis_tdata (qq2CHECKSUMout.tdata),
    .s_axis_tkeep (qq2CHECKSUMout.tkeep),
    .s_axis_tid   (qq2CHECKSUMout.tid),
    .s_axis_tlast (qq2CHECKSUMout.tlast),

    .m_axis_tvalid(qq2CHECKSUMout2.tvalid),
    .m_axis_tready(qq2CHECKSUMout2.tready),
    .m_axis_tdata (qq2CHECKSUMout2.tdata),
    .m_axis_tkeep (qq2CHECKSUMout2.tkeep),
    .m_axis_tid   (qq2CHECKSUMout2.tid),
    .m_axis_tlast (qq2CHECKSUMout2.tlast)
);

replace_last_packet_with_sha d1(
    .clock(aclk),
    .reset(areset),

    .inp_valid(qq2DATA.tvalid),
    .inp_ready(qq2DATA.tready),
    .inp_data (qq2DATA.tdata),
    .inp_keep (qq2DATA.tkeep),
    .inp_id   (qq2DATA.tid),
    .inp_last (qq2DATA.tlast),

    .chk_valid(qq2CHECKSUMout2.tvalid),
    .chk_ready(qq2CHECKSUMout2.tready),
    .chk_data (qq2CHECKSUMout2.tdata),
    .chk_keep (qq2CHECKSUMout2.tkeep),
    .chk_id   (qq2CHECKSUMout2.tid),
    .chk_last (qq2CHECKSUMout2.tlast),

    .out_valid(qq2.tvalid),
    .out_ready(qq2.tready),
    .out_data (qq2.tdata),
    .out_keep (qq2.tkeep),
    .out_id   (qq2.tid),
    .out_last (qq2.tlast)
);

axisr_data_fifo_512 fifo3 (
    .s_axis_aclk   (aclk),
    .s_axis_aresetn(areset),

    .s_axis_tvalid(qq2.tvalid),
    .s_axis_tready(qq2.tready),
    .s_axis_tdata (qq2.tdata),
    .s_axis_tkeep (qq2.tkeep),
    .s_axis_tid   (qq2.tid),
    .s_axis_tlast (qq2.tlast),

    .m_axis_tvalid(m_axis_host.tvalid),
    .m_axis_tready(m_axis_host.tready),
    .m_axis_tdata (m_axis_host.tdata),
    .m_axis_tkeep (m_axis_host.tkeep),
    .m_axis_tid   (m_axis_host.tid),
    .m_axis_tlast (m_axis_host.tlast)
);

endmodule
