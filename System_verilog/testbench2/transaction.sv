class transaction;
	rand  bit a;
 	rand  bit b;
  	bit c;
  	function void display(string name);
    	$display("------------------------");
    	$display("-%s",name);
    	$display("------------------------");
    	$display("-a=%0d, b=%0d",a,b);
    	$display("-c=%0d",c);
    	$display("------------------------");
  	endfunction
endclass