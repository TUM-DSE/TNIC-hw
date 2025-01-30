// removes checksums which are either the last packets
// or after every 4th packet

module decaesar(

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

logic [511:0] buffFlipFlopData;
logic [63:0]  buffFlipFlopKeep;
logic [5:0]  buffFlipFlopId;
logic buffFlipFlopLast;

logic [3:0] i;

always@(posedge clock)
    begin
        if (reset == 1'b0) 
            begin
                buffFlipFlopData <= 0;
                buffFlipFlopKeep <= 0;
                buffFlipFlopId <= 0;
                buffFlipFlopLast <= 0;
            end
        else
            begin
                if(!enableBuf) 
                    begin
                        buffFlipFlopData <= buffFlipFlopData;
                        buffFlipFlopKeep <= buffFlipFlopKeep;
                        buffFlipFlopId <= buffFlipFlopId;
                        buffFlipFlopLast <= buffFlipFlopLast;
                    end
                else 
                    begin
                        buffFlipFlopData <= inp_data;
                        buffFlipFlopKeep <= inp_keep;
                        buffFlipFlopId <= inp_id;
                        buffFlipFlopLast <= inp_last;
                    end
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

always@(*)
    begin
        if(!outputValues)
            begin
                out_valid = 0;
                // set defaults for output values
                out_keep = 0;
                out_id = 0;
                out_last = 0;
                out = 0;
                out_valid = 0;
            end
        else 
            begin
                out_valid = 1;

                out_keep = buffFlipFlopKeep;
                out_id = buffFlipFlopId;
                out = buffFlipFlopData;
                out_last = buffFlipFlopLast;
            end
    end

assign enableBuf = i<4 ? 1 : 0;
assign outputValues = i>0 ? 1 : 0;
assign inp_ready = 1;

endmodule
