// module adder (
//     input [3:0] a, b;
//     output [3:0] sum;
// );
//     assign sum = a + b;
// endmodule

`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

interface add_if;
    logic [3:0] a, b;
    logic [7:0] y;
endinterface 


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
                `uvm_error("GEN", "Randomization failed");
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

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    uvm_analysis_port #(transaction) send;
    transaction t;
    virtual add_if aif;

    function new(input string path="monitor", uvm_component parent=null);
        super.new(path, parent);
        send = new("send", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        t = transaction::type_id::create("t");
        if (!uvm_config_db#(virtual add_if)::get(this, "", "aif", aif))
            `uvm_error("DEV", "Unable to access uvm_config_db");
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin 
            #10;
            t.a = aif.a;
            t.b = aif.b;   
            t.y = aif.y;
            `uvm_info("MON", $sformatf("Data send to scoreboard a: %0d, b: %0d, c: %0d", t.a, t.b, t.y), UVM_NONE);
            send.write(t);
        end
    endtask
endclass

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    uvm_analysis_imp #(transaction) recv;
    transaction tr;

    function new(input string path="scoreboard", uvm_component parent=null);
        super.new(path, parent);
        send = new("recv", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin 
            #10;
            t.a = aif.a
            t.b = aif.b    
            t.y = aif.y
            `uvm_info("MON", $sformatf("Data send to scoreboard a: %0d, b: %0d, c: %0d", t.a, t.b, t.y), UVM_NONE);
            send.write(t);
        end
    endtask

    virtual function void write(transaction tr);
        tr = t;
        `uvm_info("sco", $sformatf("Data send to scoreboard a: %0d, b: %0d, c: %0d", tr.a, tr.b, tr.y), UVM_NONE);
      if(tr.y == tr.a + tr.b) 
            `uvm_info("sco", "Test passed", UVM_NONE);
        else
            `uvm_info("sco", "Test passed", UVM_NONE);
    endfunction
endclass

class agent extends uvm_agent;
    `uvm_component_utils(agent)
    monitor m;
    driver d;
    uvm_sequencer #(transaction) seq;
    
    function new(input string path="agent", uvm_component c);
        super.new(path, c);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m = monitor::type_id::create("m", this);
        d = driver::type_id::create("d", this);
        seq = uvm_sequencer #(transaction)::type_id::create("seq", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        d.seq_item_port.connect(seq.seq_item_export);
    endfunction
endclass

class env extends uvm_env;
    `uvm_component_utils(env)
    scoreboard s;
    agent a;
    
    function new(input string path="env", uvm_component c);
        super.new(path, c);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        s = scoreboard::type_id::create("s", this);
        a = agent::type_id::create("a", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        a.m.send.connect(s.recv);
    endfunction

endclass

class test extends uvm_test;
    `uvm_component_utils(test)
    generator gen;
    env e;
    
    function new(input string path="test", uvm_component c);
        super.new(path, c);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        gen = generator::type_id::create("gen", this);
        e = env::type_id::create("e", this);
    endfunction

    virtual function void run_phase(uvm_phase phase);
       phase.raise_objection(this);
       gen.start(e.a.seq);
       phase.drop_objection(this);
    endfunction

endclass

module  adder_tb;
    add_if aif();
    adder dut (aif.a, aif.b, aif.y);

    initial begin
        $dumpfile("out.vcd");
        $dumpvars();
    end

    initial begin
        uvm_config_db #(virtual add_if)::set(null, "uvm_test_top.e.a*", "aif", aif);
        run_test("test");
    end
endmodule