module mux_4x1(y,s0,s1,di);
    input s0,s1;
    input[3:0] di; 
    output y;
    wire s_0,s_1,t0,t1,t2,t3;
    not(s_0,s0);
    not(s_1,s1);
    and(t0,s_0,s_1,di[0]);
    and(t1,s_0,s1,di[1]);
    and(t2,s0,s_1,di[2]);
    and(t3,s0,s1,di[3]);
    or(y,t0 t1,t2,t3);
endmodule

module mux_16x1(y,s0,s1,s2,s3,di);
    input s0,s1,s2,s3;
    input[15:0] di;
    output y;
    wire[3:0] ti;
    mux_4x1 mx0(ti[0],s0,s1,di[3:0]);
    mux_4x1 mx1(ti[1],s0,s1,di[7:4]);
    mux_4x1 mx2(ti[2],s0,s1,di[11:8]);
    mux_4x1 mx3(ti[3],s0,s1,di[15:12]);
    mux_4x1 mx4(y,s2,s3,ti);
endmodule