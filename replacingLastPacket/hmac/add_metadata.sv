`timescale 1ns / 1ps

import lynxTypes::*;

module add_metadata #(
    parameter [63:0] FPGA_ID = '0,
    parameter [63:0] CONNECTION_ID = '0,
    parameter [63:0] INITIAL_COUNTER_VALUE = '0
) (
    input logic s_axis_aclk,
    input logic s_axis_aresetn,

    input  logic         s_axis_tvalid,
    output logic         s_axis_tready,
    input  logic [511:0] s_axis_tdata,
    input  logic [63:0]  s_axis_tkeep,
    input  logic [5:0]   s_axis_tid,
    input  logic         s_axis_tlast,

    output logic         m_axis_tvalid,
    input  logic         m_axis_tready,
    output logic [511:0] m_axis_tdata,
    output logic [63:0]  m_axis_tkeep,
    output logic [5:0]   m_axis_tid,
    output logic         m_axis_tlast
);

logic [63:0] transfer_counter;

// Buffer 1 packet during normal operation so we can replace the content of
// the second to last packet with the metadata. If !m_axis_tready but a packet
// is coming in, we have to buffer that one too in a second buffer.
logic         buf_tvalid [1:0];
logic [511:0] buf_tdata  [1:0];
logic [63:0]  buf_tkeep  [1:0];
logic [5:0]   buf_tid    [1:0];
logic         buf_tlast  [1:0];

always_ff @(posedge s_axis_aclk) begin
    if (!s_axis_aresetn) begin
        buf_tvalid[0] <= 1'b0;
        buf_tvalid[1] <= 1'b0;
        m_axis_tvalid <= 1'b0;
        s_axis_tready <= 1'b0;
        transfer_counter <= INITIAL_COUNTER_VALUE;
    end
    else if (m_axis_tready && buf_tvalid[1]) begin
        // Out ready, both buffers full
        if (buf_tlast[1]) begin
            // Last packet in buf 1, so buf 0 contains the second to last one.
            // Replace it with the metadata.
            m_axis_tvalid <= 1'b1;
            m_axis_tdata <= {{320{1'b0}}, FPGA_ID, CONNECTION_ID, transfer_counter};
            m_axis_tkeep <= {64{1'b1}};
            m_axis_tid <= buf_tid[0];
            m_axis_tlast <= buf_tlast[0];
            transfer_counter <= transfer_counter + 1'b1;
        end
        else begin
            // Send buf 0 out
            m_axis_tvalid <= 1'b1;
            m_axis_tdata <= buf_tdata[0];
            m_axis_tkeep <= buf_tkeep[0];
            m_axis_tid <= buf_tid[0];
            m_axis_tlast <= buf_tlast[0];
        end

        // Move buf 1 to buf 0
        buf_tdata[0] <= buf_tdata[1];
        buf_tkeep[0] <= buf_tkeep[1];
        buf_tid[0] <= buf_tid[1];
        buf_tlast[0] <= buf_tlast[1];
        buf_tvalid[1] <= 1'b0;

        if (s_axis_tvalid && s_axis_tready) begin
            // Store incoming data in buf 1
            buf_tvalid[1] <= 1'b1;
            buf_tdata[1] <= s_axis_tdata;
            buf_tkeep[1] <= s_axis_tkeep;
            buf_tid[1] <= s_axis_tid;
            buf_tlast[1] <= s_axis_tlast;
            // Both buffers full again
            s_axis_tready <= 1'b0;
        end else begin
            // Buf 1 is free now
            s_axis_tready <= 1'b1;
        end
    end
    else if (m_axis_tready && !buf_tvalid[1]) begin
        // Out ready, buf 1 free
        s_axis_tready <= 1'b1;
        // Default value
        m_axis_tvalid <= 1'b0;

        if (buf_tvalid[0]) begin
            if (s_axis_tvalid && s_axis_tready && s_axis_tlast) begin
                // Last packet will be saved in buf 0 next, so buf 0 currently
                // contains the second to last one. Replace it with the metadata.
                m_axis_tvalid <= 1'b1;
                m_axis_tdata <= {{320{1'b0}}, FPGA_ID, CONNECTION_ID, transfer_counter};
                m_axis_tkeep <= {64{1'b1}};
                m_axis_tid <= buf_tid[0];
                m_axis_tlast <= buf_tlast[0];
                transfer_counter <= transfer_counter + 1'b1;
            end
            else if (s_axis_tvalid && s_axis_tready && !s_axis_tlast || buf_tlast[0]) begin
                // Send buf 0 out if it's not the second to last packet or it's the last one
                m_axis_tvalid <= 1'b1;
                m_axis_tdata <= buf_tdata[0];
                m_axis_tkeep <= buf_tkeep[0];
                m_axis_tid <= buf_tid[0];
                m_axis_tlast <= buf_tlast[0];
                buf_tvalid[0] <= 1'b0;
            end
            // Keep buf 0 filled until last packet arrives so the second to last packet
            // will be in buf 0 at some point.
        end

        if (s_axis_tvalid && s_axis_tready) begin
            // Store incoming data in buf 0
            buf_tvalid[0] <= 1'b1;
            buf_tdata[0] <= s_axis_tdata;
            buf_tkeep[0] <= s_axis_tkeep;
            buf_tid[0] <= s_axis_tid;
            buf_tlast[0] <= s_axis_tlast;
        end
    end
    else begin
        // Out not ready
        s_axis_tready <= 1'b0;

        if (s_axis_tvalid && s_axis_tready) begin
            if (!buf_tvalid[0]) begin
                // Store incoming data in buf 0
                buf_tvalid[0] <= 1'b1;
                buf_tdata[0] <= s_axis_tdata;
                buf_tkeep[0] <= s_axis_tkeep;
                buf_tid[0] <= s_axis_tid;
                buf_tlast[0] <= s_axis_tlast;
            end
            else begin
                // Buf 0 is full, use buf 1
                buf_tvalid[1] <= 1'b1;
                buf_tdata[1] <= s_axis_tdata;
                buf_tkeep[1] <= s_axis_tkeep;
                buf_tid[1] <= s_axis_tid;
                buf_tlast[1] <= s_axis_tlast;
            end
        end
    end
end
endmodule
