`include "uvm_macros.svh"
import uvm_pkg::*;


class base_class extends uvm_component;
    `uvm_component_utils(base_class);
    function new(string name = "base_class", uvm_component parent);
        super.new(name, parent);
    endfunction: new
endclass

module tb();
    base_class bc;
    initial begin
        bc = new("cc", null)
    end
endmodule

