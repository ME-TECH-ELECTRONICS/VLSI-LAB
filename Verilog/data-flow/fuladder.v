module fullAdder(s,c,a,b,cin);
	input a,b,cin;
	output s,c;
	
	assign s = (a^b)^cin;
	assign c = (a&b)|((a^b)&cin);
endmodule

//Test Bench

module  fullAdder_tb;
	reg a,b,cin;
	wire s,c;

	fullAdder dut(s,c,a,b,cin);
	initial begin
		a=0; b=0; cin=0; #10;
		a=0; b=0; cin=1; #10;
		a=0; b=1; cin=0; #10;
		a=0; b=1; cin=1; #10;
		a=1; b=0; cin=0; #10;
		a=1; b=0; cin=1; #10;
		a=1; b=1; cin=0; #10;
		a=1; b=1; cin=1; #10;
	end 
endmodule
