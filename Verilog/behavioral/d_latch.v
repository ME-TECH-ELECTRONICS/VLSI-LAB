module d_latch (
    input d,
    input en,
    input rst,
    output reg q,
    output reg q_bar
);
    always @(*) begin
        if(rst) begin
            q = 0;
            q_bar = 1;
        end
        else begin 
            q = en ? d : q;
            q_bar = ~q;
        end
    end
endmodule

module d_latch_tb ();
    reg d,en,rst;
    wire q,q_bar;

    d_latch dut(d,en,rst,q,q_bar);
    initial begin
        $dumpfile("out.vcd");
        $dumpvars();
        rst = 1; en=1; #10;
        rst = 0; en=0; d=0; #10;
        rst = 0; en=0; d=1; #10;
        rst = 0; en=1; d=0; #10;
        rst = 0; en=1; d=1; #10;
    end
endmodule