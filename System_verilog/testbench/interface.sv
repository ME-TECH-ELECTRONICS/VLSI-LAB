interface adder_intf();
    logic[7:0] a;
    logic[7:0] b;
    bit[7:0] sum;
    bit carry;
endinterface

interface clk_intf;
    logic clk;
    initial clk <= 0;
    always #10 clk <= ~clk;
endinterface