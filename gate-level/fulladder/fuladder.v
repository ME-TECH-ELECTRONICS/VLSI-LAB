module fullAdder(s,c,a,b,cin);
	input a,b,cin;
	output s,c;
	wire t0,t1,t2;
	xor(s,a,b,cin);
	and(t0,a,b);
	xor(t1,a,b);
	and(t2,t1,cin);
	or(c,t0,t2);
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

