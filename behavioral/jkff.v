module jkff(
    input j,
    input k,
    input clk,
    input rst,
    output reg q
);
    always @(posedge clk) begin
        if(rst)
            q <= 0;
        else
            q = (j & (~q)) | (~k & q); 
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