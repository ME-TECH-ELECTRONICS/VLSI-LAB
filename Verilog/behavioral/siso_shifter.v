module siso_shifter (
    input i, 
    input clk,
    input rst,
    output reg o
);  
    reg[2:0] q;
    always @(posedge clk) begin
        if(rst)begin 
            o <= 0;
            q <= 0;
         end
        else begin
            q[0] <= i;
            q[1] <= q[0];
            q[2] <= q[1];
            o <= q[2];
        end
    end
endmodule

module siso_shifter_tb ();
    reg clk=0, rst;
    reg i;
    wire q;
    siso_shifter dut (i, clk, rst, q);

    always #5 clk=~clk;

    initial begin
        rst = 1; i = 0;  #10;
        rst = 0; i = 0; #10;
        rst = 0; i = 1; #10;
        rst = 0; i = 0; #10;
        rst = 0; i = 1; #10;
    end
endmodule