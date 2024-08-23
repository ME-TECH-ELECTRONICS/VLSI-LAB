module demux_2x1(d,s,y0,y1);
	input d,s;
	output y0,y1;
	assign y0 = d&(~s);
	assign y1 = d&s; 
endmodule 

//TestBench

module demux_2x1_tb;
	reg d,s;
	wire y0,y1;
	
	demux_2x1 dut(d,s,y0,y1);
	
	initial begin
		d=0; s=0; #10;
		d=1; s=0; #10;
		d=0; s=1; #10;
		d=1; s=1; #10;
	end
endmodule 