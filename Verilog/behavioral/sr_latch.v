module sr_latch (
    input s,
    input r,
    output reg q,
);
    always @(*) begin
        if(s==0 && r==0) begin
            q = q;
        end
        else if(s==0 && r==1) begin
            q = 0;
        end
        else if(s==1 && r==0) begin
            q = 1;
        end
        else if(s==1 && r==1) begin
            q = 1'bx;
        end
    end
endmodule

module sr_latch_tb();
    reg s,r;
    wire q;
    sr_latch dut(s,r,q);
    initial begin
        s = 0; r = 0;
        #10 s = 0; r = 1;
        #10 s = 1; r = 0;
        #10 s = 1; r = 1;
    end
endmodule