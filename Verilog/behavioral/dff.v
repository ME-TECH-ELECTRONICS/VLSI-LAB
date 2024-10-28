module dff (
    input wire D,
    input wire clk,
    input wire rst,
    output reg Q
);
    always @(posedge clk) begin
        if(rst) 
            Q <= 0;
        else
            Q <= D;
    end
endmodule

module tb();
    reg d,rst,clk=0;
    wire q;
    always #5 clk=~clk;
    initial begin
        #10;
        rst=1; d=0; #10;
        rst=1; d=1; #10;
        rst=0; d=0; #10;
        rst=0; d=1; #10;
    end
    initial begin
        $dumpfile("out.vcd");
        $dumpvars(1);
        #1000; $finish;
    end
endmodule