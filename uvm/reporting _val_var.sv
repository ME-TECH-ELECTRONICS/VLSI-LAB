
`include "uvm_macros.svh"
import uvm_pkg::*;
module tb;
    int val = 256;
    initial begin
        `uvm_info("tb_top", $sformat("Value: %0h", val), UVM_MEDIUM);
    end
endmodule

`include "uvm_macros.svh"
import uvm_pkg::*;

module tb;
    int val = 256;
    initial begin
        // Corrected uvm_info call with verbosity and message
        `uvm_info("tb_top", $sformat("Value: %0d", val), UVM_LOW);
    end
endmodule
