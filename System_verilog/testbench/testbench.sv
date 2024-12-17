`include "environment.sv"
`include "interface.sv"
module tb();
    adder_intf intf = new();
    Environment env = new();
    adder_8bit dut(intf);
    
    initial begin 
        env.run();
        #50 $finish;
    end
endmodule