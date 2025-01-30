module check_sha (
    input logic clock,
    input logic reset,

    input  logic         inp_valid,
    output logic         inp_ready,
    input  logic [511:0] inp_data,
    input  logic [63:0]  inp_keep,
    input  logic [5:0]   inp_id,
    input  logic         inp_last,

    input  logic comparison_valid,
    output logic comparison_ready,
    input  logic comparison_result,

    output logic         out_valid,
    input  logic         out_ready,
    output logic [511:0] out_data,
    output logic [63:0]  out_keep,
    output logic [5:0]   out_id,
    output logic         out_last
);

localparam logic [1:0]
    START = 2'b00,
    S_CORRECT = 2'b01,
    S_INCORRECT = 2'b10;

reg [1:0] current_state, next_state;

always_ff @(posedge clock) begin
    if (reset == 1'b0) begin
        current_state <= START;
    end else begin
        current_state <= next_state;
    end
end

// Choosing the next state
always_comb begin
    next_state = current_state;

    case (current_state)
        START: begin
            if (comparison_valid) begin
                if (comparison_result == 0) begin
                    next_state = S_CORRECT;
                end else begin
                    next_state = S_INCORRECT;
                end
            end
        end
        S_CORRECT: begin
            if (inp_last && inp_valid && out_ready) begin
                next_state = START;
            end
        end
        S_INCORRECT: begin
            if (inp_last && inp_valid && out_ready) begin
                next_state = START;
            end
        end
        default: begin
            // Should never happen
            next_state = START;
        end
    endcase
end

always_comb begin
    // Defaults to prevent latches
    inp_ready = 0;
    comparison_ready = 0;
    out_data = 0;
    out_valid = 0;
    out_keep = 0;
    out_id = 0;
    out_last = 0;

    case (current_state)
        START: begin
            comparison_ready = 1;
        end
        S_CORRECT: begin
            // HMAC is correct, pass the packets through
            if (inp_valid) begin
                inp_ready = out_ready;
                out_data = inp_data;
                out_valid = 1;
                out_keep = inp_keep;
                out_id = inp_id;
                out_last = inp_last;
            end
        end
        S_INCORRECT: begin
            // HMAC is incorrect, drop the packets and send zeros
            if (inp_valid) begin
                inp_ready = out_ready;
                out_data = 0;
                out_valid = 1;
                out_keep = inp_keep;
                out_id = inp_id;
                out_last = inp_last;
            end
        end
        default: begin
            // Should never happen, all signals keep their default values
        end
    endcase
end

endmodule
