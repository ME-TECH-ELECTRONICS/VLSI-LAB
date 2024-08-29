module halfAdder(s,c,a,b);
	input a,b;
	output reg s,c;
	always @(*) begin
	    s = a^b;
	    c = a&b;
    end
endmodule

//Test Bench

module halfAdder_tb;
	reg a,b;
	wire s,c;
	
	halfAdder dut(s,c,a,b);  
	initial begin
		a=0; b=0; #10;
		a=0; b=1; #10;
		a=1; b=0; #10;
		a=1; b=1; #10;
	end 
endmodule 

