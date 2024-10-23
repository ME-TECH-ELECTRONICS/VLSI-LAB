module halfsubstractor (a,b,d,br);
    	input a,b;
    	output d,br;
        wire t0;
        not(t0,a);
    	xor(d,a,b);
    	and(br,t0,b);
endmodule

//Test Bench
module halfsubstractor_tb();
    	reg a,b;
    	wire d,br;
    	halfsubstractor dut(a,b,d,br);
    	initial begin
        	a=0; b=0; #10; 
        	a=0; b=1; #10; 
        	a=1; b=0; #10; 
        	a=1; b=1; #10; 
    	end
endmodule
