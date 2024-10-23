module halfsubstractor (a,b,d,br);
    input a,b;
    output d,br;
    assign d = a^b;
    assign br = (~a)&b;
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