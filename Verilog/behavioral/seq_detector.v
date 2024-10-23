module seq_detector(
    input clk,
    input rst,
    input din,
    output reg dout
);
    parameter IDLE = 2'b00,
              S0 = 2'b01,
              S1 = 2'b10;
    reg[1:0] NS, PS;

    always @(posedge clk) begin
        if(!rst)
            PS = IDLE;
        else
            PS = NS; 

    end

    always @(PS or din) begin
        dout = 0;
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
            S1: begin
                if(din)begin
                    NS <= S0;
                    dout <= 1;
                end
                else
                    NS = IDLE;
            end
            default: NS = IDLE;
        endcase
    end
endmodule

module seq_detector_tb();
    reg clk=0,rst=1,din;
    wire out;
    seq_detector dut(clk,rst,din,out);
    always #5 clk = ~clk;
    initial begin
        rst = 0; #10;
        rst = 1; #10;
        
        din = 0; #10;
        din = 1; #10;
        din = 1; #10;
        din = 0; #10;
        din = 1; #10;
        din = 1; #10;
        din = 0; #10;
        din = 0; #10;
        din = 1; #10;
        din = 0; #10;
        din = 1; #10;
    end
endmodule