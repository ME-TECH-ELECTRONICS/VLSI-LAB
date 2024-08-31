module jkff(
    input wire j,k,clk,rst,
    output reg q
);
    always @(posedge clk) begin
        if(rst)
            q <= 0;
        else
            if (j==0 && k==0) begin
                q <= q;
            end
            else if (j==0 && k==1) begin
                q <= 0;
            end
            else if (j==1 && k==0) begin
                q <= 1;
            end
            else if (j==1 && k==1) begin
                q <= ~q;
            end
    end
endmodule

module jkff_tb();
    reg j,k,clk=0,rst;
    wire q;
    jkff dut(j,k,clk,rst,q);
    always #5 clk=~clk;

    initial begin
        rst = 1; j=0; k=0; #10;
        rst = 1; j=1; k=0; #10;
        rst = 0; j=0; k=0; #10;
        rst = 0; j=0; k=1; #10;
        rst = 0; j=1; k=0; #10;
        rst = 0; j=1; k=1; #10;
    end

endmodule