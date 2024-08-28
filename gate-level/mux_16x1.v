module mux_4x1(y,si,di);
    input[1:0] si;
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

module mux_16x1(y,si,di);
    input[3:0] si;
    input[15:0] di;
    output y;
    wire[3:0] ti;
    mux_4x1 mx0(ti[0],si[1:0],di[3:0]);
    mux_4x1 mx1(ti[1],si[1:0],di[7:4]);
    mux_4x1 mx2(ti[2],si[1:0],di[11:8]);
    mux_4x1 mx3(ti[3],si[1:0],di[15:12]);
    mux_4x1 mx4(y,si[3:2],ti);
endmodule

module mux_16x1_tb();
    reg[15:0] di;
    reg[4:0] si;
    wire y;
    mux_16x1 dut(y,si,di);
    
    initial begin
        si=4'b0000; di=4'h0001; #10;
        si=4'b0000; di=4'h0002; #10;
        si=4'b0000; di=4'h0004; #10;
        si=4'b0000; di=4'h0008; #10;
        si=4'b0000; di=4'h0010; #10;
        si=4'b0000; di=4'h0020; #10;
        si=4'b0000; di=4'h0040; #10;
        si=4'b0000; di=4'h0080; #10;
        si=4'b0000; di=4'h0100; #10;
        si=4'b0000; di=4'h0200; #10;
        si=4'b0000; di=4'h0400; #10;
        si=4'b0000; di=4'h0800; #10;
        si=4'b0000; di=4'h1000; #10;
        si=4'b0000; di=4'h2000; #10;
        si=4'b0000; di=4'h4000; #10;
        si=4'b0000; di=4'h8000; #10;
    end
endmodule