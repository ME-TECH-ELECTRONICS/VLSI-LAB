
`include "interface.sv"
`include "environment.sv"

module tb();
    adder_intf intf();
    Environment env = new(intf);
    adder_8bit dut(intf);
    
    initial begin 
        env.run();
        #50 $finish;
    end
endmodule