`include "uvm_macros.svh"
import uvm_pkg::*;
module tb;
    initial begin
        #10;
        `uvm_info("TB_TOP", "helloworld: uvm_info", UVM_MEDIUM);
        $display("[TB_TOP] hell0 world: $display @%0t", $time);
    end
endmodule

