`include "interface.sv"
`include "environment.sv"

module tb();
  	router_if intf();
  	Environment env = new(intf);

  router dut(intf.clk, intf.rst, intf.data, intf.pkt_valid, intf.rd_en_0, intf.rd_en_1, intf.rd_en_2, intf.vld_out_0, intf.vld_out_1, intf.vld_out_2, intf.err, intf.busy, intf.dout_0, intf.dout_1, intf.dout_2);
  	initial begin
   		env.run();
        #50 $finish;
  	end
  	initial begin
        $dumpfile("out.vcd");
        $dumpvars(1);
    end
endmodule