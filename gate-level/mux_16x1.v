module mux_4x1(y,s0,s1,d0,d1,d2,d3);
    input d0,d1,d2,d3,s0,s1;
    output y;
    wire s_0,s_1,t0,t1,t2,t3;
    not(s_0,s0);
    not(s_1,s1);
    and(t0,s_0,s_1,d0);
    and(t1,s_0,s1,d1);
    and(t2,s0,s_1,d2);
    and(t3,s0,s1,d3);
    or(y,t0 t1,t2,t3);
endmodule

module mux_16x1(y,s0,s1,s2,s3,di);
    input s0,s1,s2,s3;
    input[15:0]
endmodule