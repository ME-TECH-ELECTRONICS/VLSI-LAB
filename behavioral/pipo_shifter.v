module pipo_shifter(
    input[3:0] i, 
    input clk,
    input rst,
    output reg[3:0] q
    );
    always @(posedge clk) begin
        if(rst)begin 
            q <= 0;
         end
        else begin
            
            q[0] <= i[0];
            q[1] <= i[1];
            q[2] <= i[2];
            q[3] <= i[3];
        end
    end 
endmodule

module pipo_shifter_tb();
    reg clk=0, rst;
    reg[3:0] i;
    wire[3:0] q;
    pipo_shifter dut (i, clk, rst, q);

    always #5 clk=~clk;

    initial begin
        rst = 1; i = 0;  #10;
        rst = 0; i = 4'b1010; #10;
        
    end
endmodule


