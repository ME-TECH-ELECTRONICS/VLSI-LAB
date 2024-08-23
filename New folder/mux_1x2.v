module mux_2x1(d0,d1,s,y);
	input d0,d1,s;
	output y;
	assign y = (d0&(~s))| (d1&s);
endmodule

//TestBench

module mux_2x1_tb;
	reg d0,d1,s;
	wire y;
	
	mux_2x1 dut(d0,d1,s,y);
	
	initial begin
		s=0; d0=0; d1=0; #10;
		s=0; d0=0; d1=1; #10;
		s=0; d0=1; d1=0; #10;
		s=0; d0=1; d1=1; #10;
		s=1; d0=0; d1=0; #10;
		s=1; d0=0; d1=1; #10;
		s=1; d0=1; d1=0; #10;
		s=1; d0=1; d1=1; #10;
	end
endmodule
	