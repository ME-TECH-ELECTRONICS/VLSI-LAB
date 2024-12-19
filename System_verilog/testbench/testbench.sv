
`include "interface.sv"
`include "environment.sv"

module tb();
    adder_intf intf();
    clk_intf clk_intf();
    Environment env = new(intf, clk_intf);
    adder_8bit dut(intf);
    
    initial begin 
        env.run();
        #50 $finish;
    end
  	initial begin
        $dumpfile("out.vcd");
        $dumpvars(1);
    end
endmodule