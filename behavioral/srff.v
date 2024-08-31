module srff (
    input wire s,
    input wire r,
    input wire clk,
    input wire rst,
    output reg q
);
    always @(posedge clk) begin
        if(rst)
            q <= 0;
        else if(s)
            q <= 1;
        else if(r)
            q <= 0;
        else
            q <= q;

    end
endmodule

module  srff_tb();
    reg s,r,clk=0,rst;
    wire q;
    srff dut(s,r,clk,rst,q);
    always #5 clk=~clk;

    initial begin
        rst = 1; s=0; r=0; #10;
        rst = 1; s=1; r=0; #10;
        rst = 0; s=0; r=0; #10;
        rst = 0; s=0; r=1; #10;
        rst = 0; s=1; r=0; #10;
        rst = 0; s=1; r=1; #10;
        #10;
    end
endmodule