module halfsubstractor (a,b,d,br);
    input a,b;
    output reg d,br;
    always @(*) begin
        d = a^b;
        br = (~a)&b;
    end
endmodule

//Test Bench
module halfsubstractor_tb();
    reg a,b;
    wire d,br;
    halfsubstractor dut(a,b,d,br);
    initial begin
        a=0; b=0; #10; 
        a=0; b=1; #10; 
        a=1; b=0; #10; 
        a=1; b=1; #10; 
    end
endmodule