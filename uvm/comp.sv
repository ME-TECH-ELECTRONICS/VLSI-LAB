`include "uvm_macros.svh"
import uvm_pkg::*;

class test extends uvm_test;
    `uvm_component_utils(test);
    
    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TEST", "Build phase execued" UVM_NONE);
    endfunction

    virtual function void connet_phase(uvm_phase phase);
        super.connet_phase(phase);
        `uvm_info("TEST", "Build phase execued" UVM_NONE);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TEST", "Build phase execued" UVM_NONE);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TEST", "Build phase execued" UVM_NONE);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TEST", "Build phase execued" UVM_NONE);
    endfunction

endclass 