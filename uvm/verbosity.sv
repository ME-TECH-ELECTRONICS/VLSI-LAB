
`include "uvm_macros.svh"
import uvm_pkg::*;
module tb;
    int verbosity=0;
    initial begin
        uvm_top.set_report_verbosity_level(UVM_HIGH);
        $display("default verbosity level");
        `uvm_info("tb_top","this is informative message",UVM_HIGH);
    end
endmodule