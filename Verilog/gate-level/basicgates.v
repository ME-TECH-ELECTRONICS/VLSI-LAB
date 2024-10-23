module basicGates(A,B,NY,AY,OY,NAY,NOY,XY,XNY);
	input A,B;
	output NY,AY,OY,NAY,NOY,XY,XNY;
	not(NY,A);
	and(AY, A, B);
	or(OY, A, B);
	nand(NAY, A, B);
	nor(NOY, A, B);
	xor(XY, A, B);
	xnor(XNY,A,B);
endmodule

//Test bench

module basicgates_tb;
	reg a,b;
	wire NY,AY,OY,NAY,NOY,XY,XNY;
	basicGates hh(a,b,NY,AY,OY,NAY,NOY,XY,XNY);
	initial begin
		a=0; b=0; #10ns;
		a=0; b=1; #10ns;
		a=1; b=0; #10ns;
		a=1; b=1; #10ns;
		#100ns;
    	$finish;
	end
endmodule
	