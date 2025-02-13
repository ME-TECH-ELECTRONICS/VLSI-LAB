module adder (
    input [3:0] a, b;
    output [3:0] sum;
);
    assign sum = a + b;
endmodule

interface intf;
    logic [3:0] a, b;
    logic [7:0] sum;
endinterface 


`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
    rand bit [3:0] a;
    rand bit [3:0] b;
    bit [4:0] y;

    function new(input string path="transaction");
        super.new(path);
    endfunction

    `uvm_object_utils_begin(transaction)
        `uvm_field_int(a, UVM_DEFAULT)
        `uvm_field_int(b, UVM_DEFAULT)
        `uvm_field_int(y, UVM_DEFAULT)
    `uvm_object_utils_end
endclass

class generator extends uvm_sequence#(transaction);
    `uvm_object_utils(generator)

    transaction t;
    integer i;

    function new(input string path="generator");
        super.new(path);
    endfunction

    virtual task body();
        repeat(10) begin
            t = transaction::type_id::create("t"); // Allocate memory
            start_item(t);
            if (!t.randomize())
                `uvm_error("GEN", "Randomization failed")
            `uvm_info("GEN", $sformatf("Data sent to driver a:%0d, b:%0d", t.a, t.b), UVM_NONE);
            finish_item(t);
        end
    endtask
endclass 

class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)

    function new(input string path="driver", uvm_component parent=null);
        super.new(path, parent);
    endfunction

    transaction tc;
    virtual add_if aif; // Ensure add_if is defined elsewhere

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tc = transaction::type_id::create("tc");

        if (!uvm_config_db#(virtual add_if)::get(this, "", "aif", aif))
            `uvm_error("DEV", "Unable to access uvm_config_db");
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tc);
            aif.a <= tc.a;
            aif.b <= tc.b;
            `uvm_info("DEV", $sformatf("Trigger DUT: a:%0d, b:%0d", tc.a, tc.b), UVM_NONE);
            seq_item_port.item_done();
            #10;
        end
    endtask
endclass
