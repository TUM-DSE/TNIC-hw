module replace_last_packet_with_sha
(
    input logic clock,
    input logic reset,

    input  logic         inp_valid,
    output logic         inp_ready,
    input  logic [511:0] inp_data,
    input  logic [63:0]  inp_keep,
    input  logic [5:0]   inp_id,
    input  logic         inp_last,

    input  logic         chk_valid,
    output logic         chk_ready,
    input  logic [511:0] chk_data,
    input  logic [63:0]  chk_keep,
    input  logic [5:0]   chk_id,
    input  logic         chk_last,

    output logic         out_valid,
    input  logic         out_ready,
    output logic [511:0] out_data,
    output logic [63:0]  out_keep,
    output logic [5:0]   out_id,
    output logic         out_last
);

localparam logic [0:0]
    S0 = 1'b0,
    S1 = 1'b1;

reg [0:0] current_state, next_state;

always_ff @(posedge clock) begin
    if(reset == 1'b0) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Choosing the next state
always_comb begin
    next_state = current_state;

    case (current_state)
        S0: begin
            if (inp_valid && inp_last) begin
                next_state = S1;
            end
        end
        S1: begin
            if (chk_valid && inp_valid && out_ready) begin
                next_state = S0;
            end
        end
    endcase
end


always_comb begin
    // Defaults to prevent latches
    inp_ready = 0;
    out_data = 0;
    out_valid = 0;
    chk_ready = 0;
    out_keep = 0;
    out_id = 0;
    out_last = 0;

    case (current_state)
        S0: begin
            // Pass through all inp packets except the last one
            if (inp_valid && !inp_last) begin
                inp_ready = out_ready;
                out_data = inp_data;
                out_valid = 1;
                out_keep = inp_keep;
                out_id = inp_id;
                out_last = 0; // Input is never last
            end
        end
        S1: begin
            // Replace the last inp packet with the HMAC in chk_data
            if (chk_valid && inp_valid && inp_last) begin
                chk_ready = out_ready;
                inp_ready = out_ready;
                out_data = chk_data;
                out_valid = 1;
                out_keep = chk_keep;
                out_id = chk_id;
                out_last = 1;
            end
        end
    endcase
end

endmodule
