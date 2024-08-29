module halfsubstractor (a,b,d,br);
    input a,b;
    output reg d,br;
    always @(*) begin
        d = a^b;
        br = (~a)&b;
    end
endmodule

module fullsubstractor (a,b,c,d,br);
    input a,b,c;
    output d,br;
    wire t0,t1,t2;
    halfsubstractor hs0(a,b,t0,t1);
    halfsubstractor hs1(t0,c,d,t2);
    assign br = t1 | t2;
endmodule

module fullsubstractor_tb();
    reg a,b,c;
    wire d,br;
    fullsubstractor dut(a,b,c,d,br);

    initial begin
        a=0; b=0; c=0; #10;
        a=0; b=0; c=1; #10;
        a=0; b=1; c=0; #10;
        a=0; b=1; c=1; #10;
        a=1; b=0; c=0; #10;
        a=1; b=0; c=1; #10;
        a=1; b=1; c=0; #10;
        a=1; b=1; c=1; #10;
    end
endmodule