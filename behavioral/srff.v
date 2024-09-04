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
        else 
            if(s&r) 
                q <= 1'bx;
            else 
                q = s | (~r & q);
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