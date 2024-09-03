module down_counter_3b (
    input clk,
    input rst,
    output reg[2:0] q 
);
    always @(posedge clk) begin
        if(rst) 
            q=7;
        else 
            q = q-1;
    end
endmodule

module down_counter_3b_tb ();
    reg clk=0,rst;
    wire [2:0] q;
    up_counter_3b dut (clk,rst,q);
    always #5 clk = ~clk;
    initial begin
        rst = 1; #10;
        rst = 0;
    end
endmodule