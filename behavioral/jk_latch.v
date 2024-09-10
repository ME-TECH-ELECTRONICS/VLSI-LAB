module jk_latch (
    input j,
    input k,
    input en,
    input rst,
    output reg q,
    output reg q_bar
);
    always @(*) begin
        if(rst) begin
            q = 0;
        end
        else begin 
            if(en) begin
                case (t)
                    0 : q = q;
                    1 : q = #2 ~q;
                endcase
                // q = en ? (t ? #1 ~q : q) : q;
            end
        end
    end
    always @(*) begin
        q_bar = ~q;
    end
endmodule

module jk_latch_tb ();
    reg t,en,rst;
    wire q,q_bar;

    jk_latch dut(t,en,rst,q,q_bar);
    initial begin
        rst = 1; en=1; #10;
        rst = 0; en=0; t=0; #10;
        rst = 0; en=0; t=1; #10;
        rst = 0; en=1; t=0; #10;
        rst = 0; en=1; t=1; #10;
        rst = 0; en=1; t=1; #10;
        rst = 0; en=1; t=1; #10;
    end
endmodule