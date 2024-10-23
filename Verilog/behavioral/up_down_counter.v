module up_down_counter_3b (
    input clk,
    input rst,
    input mode,
    output reg[2:0] q
);
    always @(posedge clk) begin
        if(rst) 
            q = mode ? 0 : 7;
        else 
            q = mode ? q + 1 : q - 1;
    end
endmodule

module up_down_counter_3b_tb();
    reg clk=0,rst,mode=1;
    wire [2:0] q;
    up_down_counter_3b dut (clk,rst,mode,q);
    always #5 clk = ~clk;
    initial begin
        rst = 1; #10;
        rst = 0; mode=1; #100;
        rst = 1; mode=0; #10;
        rst = 0; mode=0; #100;
    end
endmodule