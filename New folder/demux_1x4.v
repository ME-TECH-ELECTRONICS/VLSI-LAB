
module demux_2x1(d,s,y0,y1);
	input d,s;
	output y0,y1;
	assign y0 = d&(~s);
	assign y1 = d&s; 
endmodule 

module demux_1x4(d,s0, s1,y0,y1);
	input s,d;
	output y0,y1,y2,y3;
	wire  
	demux_1x4 dx0(d,s0,t1,t2);
	demux_1x4 dx1(d,s1,y0,y1);
	demux_1x4 dx2(d,s1,y2,y3);
//TestBench

module demux_1x4_tb;
	reg d,s0,s1;
	wire y0,y1,y2,y3;
	
	demux_1x4 dut(d,s,y0,y1);
	
	initial begin
		s0=0; s1=0; y0=1; y1=0; y2=0; y3=1; #10;
		s0=0; s1=0; y0=0; y1=1; y2=1; y3=1; #10;
		s0=0; s1=1; y0=0; y1=1; y2=0; y3=0; #10;
		s0=0; s1=1; y0=1; y1=0; y2=1; y3=1; #10;
		s0=1; s1=0; y0=0; y1=0; y2=1; y3=0; #10;
		s0=1; s1=0; y0=1; y1=1; y2=0; y3=1; #10;
		s0=1; s1=1; y0=0; y1=0; y2=0; y3=1; #10;
		s0=1; s1=1; y0=1; y1=1; y2=1; y3=0; #10;
	end
endmodule 