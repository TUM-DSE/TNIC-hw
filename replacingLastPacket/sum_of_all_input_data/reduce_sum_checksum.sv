module reduce_sum_checksum(

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

logic [511:0] accumulator;


always@(posedge clock)
    begin
        if (reset == 1'b0 || (inp_valid && inp_last)) 
            begin
                accumulator <= 0;
            end
        else
            begin
                if(!inp_valid) 
                    begin
                        accumulator <= accumulator;
                    end
                else 
                    begin
                        accumulator <= accumulator + inp_data;
                    end
            end
    end

assign inp_ready = 1;

always@(*)
    begin
        if(inp_valid && inp_last)
            begin
                // set defaults for output values
                out_keep = inp_keep;
                out_id = inp_id;
                out_last = 1;
                out = accumulator + inp_data;
                out_valid = 1;
            end
        else 
            begin
                out_valid = 0;
                out_keep = 0;
                out_id = 0;
                out_last = 0;
                out = 0;
            end
    end


endmodule