module tff (
    input wire t,
    input wire clk,
    input wire rst,
    output reg q
);
    always @(posedge clk) begin
        if(rst)
            q <= 0;
        else
            q <= ~q & t;
    end
endmodule

module tff_tb ();
    reg t, clk = 0,rst;
    wire q;
    tff dut(t,clk,rst,q);
    always #5 clk=~clk;

    initial begin
        rst = 1; t=0; #10;
        rst = 1; t=1; #10;
        rst = 0; t=0; #10;
        rst = 0; t=1; #10;
        #10;
    end
endmodule