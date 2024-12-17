`include "environment.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "interface.sv"
`include "transaction.sv"

module tb();
    adder_intf intf();
    Environment env = new();
    adder_8bit dut(intf);
    
    initial begin 
        env.run();
        #50 $finish;
    end
endmodule