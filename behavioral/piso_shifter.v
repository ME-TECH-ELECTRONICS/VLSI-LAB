module piso_shifter(
    input[3:0] i, 
    input clk,
    input rst,
    input l_s,
    output reg o
    );
    reg[2:0] q;
    always @(posedge clk) begin
        if(rst)begin 
            q <= 0;
            o <= 0;
         end
        else begin
            q[0] <= i[0];
            q[1] <= l_s ? q[0] : i[1];
            q[2] <= l_s ? q[1] : i[2];
            o <= l_s ? q[2] : i[3];
        end
    end 
endmodule

module piso_shifter_tb();
    reg clk=0, rst, l_s;
    reg[3:0] i;
    wire q;
    piso_shifter dut (i, clk, rst, l_s, q);

    always #5 clk=~clk;

    initial begin
        rst = 1; i = 0;  #10;
        rst = 0; i = 4'b1010; l_s = 0; #10;
        rst = 0; i = 4'b1010; l_s = 1; #10;
        
    end
endmodule


