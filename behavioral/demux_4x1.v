
module demux_1x2(d,s,y0,y1);
	input d,s;
	output reg y0,y1;
	always @(*) begin
        y0 = d&(~s);
	    y1 = d&s; 
    end
endmodule 

module demux_1x4(d,s0,s1,y0,y1,y2,y3);
	input s0,s1,d;
	output y0,y1,y2,y3;
	wire t1,t2; 
	demux_1x2 d0(d,s0,t1,t2);
	demux_1x2 d1(t1,s1,y0,y1);
	demux_1x2 d2(t2,s1,y2,y3);
endmodule
//TestBench

module demux_1x4_tb;
	reg d,s0,s1;
	wire y0,y1,y2,y3;
	demux_1x4 dut(d,s0,s1,y0,y1,y2,y3);
	initial begin
		d=0; s0=0; s1=0; #10;  d=1; s0=0; s1=0; #10;
		d=0; s0=0; s1=1; #10;  d=1; s0=0; s1=1; #10;
		d=0; s0=1; s1=0; #10;  d=1; s0=1; s1=0; #10;
		d=0; s0=1; s1=1; #10;  d=1; s0=1; s1=1; #10;
	end
endmodule 