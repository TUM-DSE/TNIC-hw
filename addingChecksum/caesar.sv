// state machine that produces checksums every 4th message or after tlast
module caesar(

    input logic clock,
    input logic reset,

    input logic [511:0] inp_data,
    input logic inp_valid,
    output logic inp_ready,
    input logic [63:0] inp_keep,
    input logic [5:0] inp_id,
    input logic inp_last,
    

    output logic [511:0] out,
    output logic out_valid,
    input logic out_ready,
    output logic [63:0] out_keep,
    output logic [5:0] out_id,
    output logic out_last
);


logic [3:0] i;
        
logic [5:0] bufferedTid;
logic bufferedTlast;


parameter [0:0]
	S0 = 1'b0,
	S1 = 1'b1;
	
reg[0:0] current_state, next_state;

always @(posedge clock)
    if (reset == 1'b0)
        current_state <= S0;
    else
	    current_state <= next_state;


// choosing the next state
always @(*)
	begin
		next_state = current_state;
        
        case (current_state)
            S0: begin
                    if ((inp_valid && inp_last) || i == 3)
                        next_state = S1;
                end
            S1: begin
                    next_state = S0;
                end
        endcase
	end

// producing the output
always@(*)
    begin
        if (current_state == S1)
            begin
                ////// produce the checksum
                out = 420;
                out_valid = 1;
                out_keep = 'hffff;

                out_id = bufferedTid;
                out_last = bufferedTlast;
                /////
            end
        else
            begin
                ////// defaults for output values
                out = 0;
                out_valid = 0;
                out_keep = 0;
                out_id = 0;
                out_last = 0; 
                //// end of defaults
            end
    end

always@(posedge clock)
    begin
        if (reset == 1'b0 || (inp_valid && inp_last))
            begin
                i<=0;
            end
        else
            begin
                if(inp_valid)
                    begin 
                        if (i<4)
                            begin
                                i<=i + 1;
                            end
                        else 
                            begin
                                i<=0;
                            end
                    end
                else 
                    begin
                        i<=i;
                    end
            end
    end

always@(posedge clock)
    if (reset == 1'b0)
        begin
            bufferedTid <= 0;
            bufferedTlast <= 0;
        end
    else
        begin
            if(inp_valid)
                begin
                    bufferedTid <= inp_id;
                    bufferedTlast <= inp_last;
                end
            else
                begin
                    bufferedTid <= bufferedTid;
                    bufferedTlast <= bufferedTlast;
                end
        end

endmodule
