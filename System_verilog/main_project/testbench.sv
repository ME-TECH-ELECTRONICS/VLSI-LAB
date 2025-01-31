`include "interface.sv"
`include "environment.sv"

module tb();
   	router_if intf(); // Instantiate the router interface
   	Environment env = new(intf); // Create environment instance with the interface

   	router dut(intf.clk, intf.rst, intf.data, intf.pkt_valid, intf.rd_en_0, intf.rd_en_1, intf.rd_en_2, intf.vld_out_0, intf.vld_out_1, intf.vld_out_2, intf.err, intf.busy, intf.dout_0, intf.dout_1, intf.dout_2); // Instantiate the router DUT
  
   	initial begin
   		env.run(); // Execute testbench environment
   	end
  
   	initial begin
      	$dumpfile("out.vcd"); // Specify the VCD file for waveform dumping
        	$dumpvars(1); // Dump all variables for debugging
      	#2000 $finish; // Terminate simulation after 2000 time units
    	end
endmodule
