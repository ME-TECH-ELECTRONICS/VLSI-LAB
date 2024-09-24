module jk_latch (
    input j,
    input k,
    input en,
    input rst,
    output reg q
);
    always @(*) begin
        if(rst) begin
            q = 0;
        end
        else begin 
            if(en) begin
                if(j ==0 && k == 0) begin
                    q = q;
                end
                else if(j == 0 && k == 1) begin
                    q = 0;
                end
                else if(j == 1 && k == 0) begin
                    q = 1;
                end
                else if(j == 1 && k == 1) begin
                    q = ~q;
                end
            end
        end
    end
endmodule

module jk_latch_tb ();
    reg j,k,en,rst;
    wire q;

    jk_latch dut(j,k,en,rst,q);
    initial begin
        rst = 1; en=1; #10;
        rst = 0; en=0; j=0; k=0;#10;
        rst = 0; en=0; j=1; k=1;#10;
        rst = 0; en=1; j=0; k=0;#10;
        rst = 0; en=1; j=0; k=1;#10;
        rst = 0; en=1; j=1; k=0;#10;
        rst = 0; en=1; j=1; k=1;#10;
    end
endmodule