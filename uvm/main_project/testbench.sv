`include "uvm_macros.svh"
import uvm_pkg::*;

interface router_if(input logic clk, input logic rst);
    logic [7:0] d_in;
    logic pkt_valid;
    logic rd_en_0, rd_en_1, rd_en_2;
    logic vld_out_0, vld_out_1, vld_out_2;
    logic err, busy;
    logic [7:0] dout_0, dout_1, dout_2;
endinterface


// Transaction class
class transaction extends uvm_sequence_item;
    rand logic [7:0] d_in;
    rand bit[7:0] header;
    logic pkt_valid;
    logic rd_en_0 = 1, rd_en_1 = 1, rd_en_2 = 1;
    
    logic [7:0] parity = 0;
    logic vld_out_0, vld_out_1, vld_out_2;
    logic err, busy;
    logic [7:0] dout_0, dout_1, dout_2;

    constraint con1 { 
        header[1:0] != 2'b11; 
        header[7:2] inside {[1:63]};
        
    }
    
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(d_in, UVM_DEFAULT);
        `uvm_field_int(header, UVM_DEFAULT);
        `uvm_field_int(parity, UVM_DEFAULT);
        `uvm_field_int(pkt_valid, UVM_DEFAULT);
        `uvm_field_int(rd_en_0, UVM_DEFAULT);
        `uvm_field_int(rd_en_1, UVM_DEFAULT);
        `uvm_field_int(rd_en_2, UVM_DEFAULT);
        `uvm_field_int(vld_out_0, UVM_DEFAULT);
        `uvm_field_int(vld_out_1, UVM_DEFAULT);
        `uvm_field_int(vld_out_2, UVM_DEFAULT);
        `uvm_field_int(err, UVM_DEFAULT);
        `uvm_field_int(busy, UVM_DEFAULT);
        `uvm_field_int(dout_0, UVM_DEFAULT);
        `uvm_field_int(dout_1, UVM_DEFAULT);
        `uvm_field_int(dout_2, UVM_DEFAULT);
    `uvm_object_utils_end
    
    function new(string name = "TRANSACTION");
        super.new(name);
    endfunction
endclass

class sequences extends uvm_sequence #(transaction);
    transaction trans;
    `uvm_object_utils(sequences)
    
    function new(string name = "SEQUENCES");
        super.new(name);
    endfunction
    
    virtual task body();
        bit [7:0] header;
        int count;
        bit [7:0] parity = 0;
        
        // Send Header
        trans = transaction::type_id::create("trans");
        trans.pkt_valid = 1;
        start_item(trans);
        assert(trans.randomize());
        header = trans.d_in; // Assign header value
        finish_item(trans);
        
        count = header[7:2]; // Extract count from header
        parity = header; // Initialize parity with header
        
        // Generate Payload
        repeat (count) begin 
            trans = transaction::type_id::create("trans");
            trans.pkt_valid = 1;
            start_item(trans);
            assert(trans.randomize());
            parity ^= trans.d_in; // Update parity with new data
            finish_item(trans);
        end
        
        // Send Parity
        trans = transaction::type_id::create("trans");
        start_item(trans);
        trans.pkt_valid = 0;
        trans.d_in = parity; // Assign computed parity
        finish_item(trans);
    endtask
endclass

class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)
    
    virtual router_if vif;
    transaction trans;
    int len = 0;
    int count = 0; // ✅ Ensure count persists across loop iterations

    function new(string name = "DRIVER", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = transaction::type_id::create("trans", this);
        if (!uvm_config_db#(virtual router_if)::get(this, "", "vif", vif))
            `uvm_fatal("router_driver", "Virtual interface not set")
    endfunction

    task run_phase(uvm_phase phase);
        wait(vif.busy == 0);
            @(negedge vif.clk)
            seq_item_port.get_next_item(trans);
            vif.pkt_valid = trans.pkt_valid;
            vif.d_in = trans.d_in;
            len = int'(trans.d_in[7:2] + 1); // ✅ Capture header properly at first iteration
            seq_item_port.item_done();
            @(negedge vif.clk)
            // @(negedge vif.clk)

        forever begin
            wait(vif.busy == 0);
            @(negedge vif.clk)
            seq_item_port.get_next_item(trans);
            vif.pkt_valid = trans.pkt_valid;
            vif.d_in    = trans.d_in;
            vif.rd_en_0 = trans.rd_en_0;
            vif.rd_en_1 = trans.rd_en_1;
            vif.rd_en_2 = trans.rd_en_2;

            seq_item_port.item_done();
            count = count + 1;
        end
    endtask
endclass


// Monitor
class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    virtual router_if vif;
    transaction trans;
    uvm_analysis_port #(transaction) send;
    
    function new(string name = "MONITOR", uvm_component parent = null);
        super.new(name, parent);
        send = new("send", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = transaction::type_id::create("trans");
        if (!uvm_config_db#(virtual router_if)::get(this, "", "vif", vif))
            `uvm_fatal("monitor", "Virtual interface not set")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            @(negedge vif.clk);
            #1;
            trans.dout_0     =  vif.dout_0;
            trans.dout_1     =  vif.dout_1;
            trans.dout_2     =  vif.dout_2;
            trans.vld_out_0  =  vif.vld_out_0;
            trans.vld_out_1  =  vif.vld_out_1;
            trans.vld_out_2  =  vif.vld_out_2;
            trans.err        =  vif.err;
            trans.busy       =  vif.busy;
            // `uvm_info("MONITOR", $sformatf("Received Output: dout_0=%0h, dout_1=%0h, dout_2=%0h, din=%0h, vld_out=%0h", trans.dout_0, trans.dout_1, trans.dout_2, vif.d_in,vif.vld_out_1), UVM_NONE);
            send.write(trans);
        end
    endtask
endclass

// Scoreboard
class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    transaction trans;
    uvm_analysis_imp #(transaction, scoreboard) recv;
    
    function new(string name = "SCOREBOARD", uvm_component parent = null);
        super.new(name, parent);
        recv = new("send", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = transaction::type_id::create("trans", this);
    endfunction
    
    virtual function void write(input transaction t);
        trans = t;
        `uvm_info("SCOREBOARD", $sformatf("Received Output: dout_0=%0h, dout_1=%0h, dout_2=%0h", trans.dout_0, trans.dout_1, trans.dout_2), UVM_MEDIUM)
    endfunction
endclass

class agent extends uvm_agent;
    `uvm_component_utils(agent)
    uvm_sequencer #(transaction) sqr;
    driver drv;
    monitor mon;

    function new(string comp = "AGENT", uvm_component parent = null);
      super.new(comp, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sqr = uvm_sequencer#(transaction)::type_id::create("sqr", this);
      drv = driver::type_id::create("drv", this);
      mon = monitor::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
  
endclass

// Environment
class environment extends uvm_env;
    `uvm_component_utils(environment)
    
    agent agt;
    scoreboard sbd;
    
    function new(string name = "ENVIRONMENT", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
        agt = agent::type_id::create("agt", this);
        sbd = scoreboard::type_id::create("sbd", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.send.connect(sbd.recv);
        
    endfunction 
endclass

// Test
class test extends uvm_test;
    `uvm_component_utils(test)
    
    environment env;
    sequences seq;
    
    function new(string name = "TEST", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = environment::type_id::create("env", this);
        seq = sequences::type_id::create("seq");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(env.agt.sqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

module tb_top;
    logic clk = 0;
    logic rst;

    // Clock generation
    always #5 clk = ~clk;

    // Interface instance
    router_if tb_if (clk, rst);

    // DUT instance
    router DUT (
        tb_if.clk,
        tb_if.rst,
        tb_if.d_in,
        tb_if.pkt_valid,
        tb_if.rd_en_0,
        tb_if.rd_en_1,
        tb_if.rd_en_2,
        tb_if.vld_out_0,
        tb_if.vld_out_1,
        tb_if.vld_out_2,
        tb_if.err,
        tb_if.busy,
        tb_if.dout_0,
        tb_if.dout_1,
        tb_if.dout_2
    );

    // Run UVM test
    initial begin
        
        uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt*", "vif", tb_if);
        run_test("test");
    end
    initial begin
        rst = 0;
        #10 rst = 1;
      end
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        #1000 $finish;
      end
endmodule