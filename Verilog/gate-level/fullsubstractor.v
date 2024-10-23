module halfsubstractor (a,b,d,br);
    input a,b;
    output d,br;
    wire t0;
    not(t0,a);
    xor(d,a,b);
    and(br,t0,b);
endmodule

module fullsubstractor (a,b,c,d,br);
    input a,b,c;
    output d,br;
    wire t0,t1,t2;
    halfsubstractor hs0(a,b,t0,t1);
    halfsubstractor hs1(t0,c,d,t2);
    or(br,t1,t2);
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