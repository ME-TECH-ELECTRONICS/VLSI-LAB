module seq_detector (
    input clk,
    input rst,
    input din,
    output reg dout
);
    parameter IDLE = 2'b00,
              S0 = 2'b01,
              S1 = 2'b10,
              S2 = 2'b11;
    reg[2:0] NS, PS;

    always @(posedge clk) begin
        if(!rst)
            PS = IDLE;
        else
            PS = NS; 

    end

    always @(*) begin
        out = 0;
        case (PS)
            IDLE :  begin
                if(din)
                    NS = S0;
                else 
                    NS = IDLE;
            end
            S0 : begin
                if(din)
                    NS = S0;
                else 
                    NS = S1;
            end
            S1 : begin
                if(din)
                    NS = S2;
                else
                    NS = IDLE;
            end
            S2 : begin
                out = 1;
                if(din)
                    NS = S0;
                else
                    NS = S1;
            end
            default: 
        endcase
    end
endmodule