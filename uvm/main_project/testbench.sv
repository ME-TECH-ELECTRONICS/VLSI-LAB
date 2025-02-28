

`include "uvm_macros.svh"
import uvm_pkg::*;

interface router_if(input logic clk, input logic rst);
    logic [7:0] d_in;
    logic pkt_valid;
    logic rd_en_0, rd_en_1, rd_en_2;
    logic vld_out_0, vld_out_1, vld_out_2;
    logic err, busy;
    logic [7:0] dout_0, dout_1, dout_2;

    // modport DUT (
    //     input clk, rst, d_in, pkt_valid, rd_en_0, rd_en_1, rd_en_2,
    //     output vld_out_0, vld_out_1, vld_out_2, err, busy, dout_0, dout_1, dout_2
    // );

    // modport TB (
    //     input clk, rst,
    //     output d_in, pkt_valid, rd_en_0, rd_en_1, rd_en_2,
    //     input vld_out_0, vld_out_1, vld_out_2, err, busy, dout_0, dout_1, dout_2
    // );
endinterface


// Transaction class
class transaction extends uvm_sequence_item;
    rand logic [7:0] d_in;
    rand logic pkt_valid;
    randc logic rd_en_0, rd_en_1, rd_en_2;
    
    logic vld_out_0, vld_out_1, vld_out_2;
    logic err, busy;
    logic [7:0] dout_0, dout_1, dout_2;
    
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(d_in, UVM_DEFAULT);
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
    
    function new(string name = "transaction");
        super.new(name);
    endfunction
endclass

// Generator (Sequence)
class sequences extends uvm_sequence #(router_transaction);
    transaction t;
    `uvm_object_utils(sequences)
    
    function new(string name = "sequences");
        super.new(name);
    endfunction
    
    virtual task body();
        t = transaction::type_id::create("t");

        start_item(t);
        assert(t.randomize());
        `uvm_info("SEQUENCE", $sformatf("Generated Input: d_in=%0h, pkt_valid=%0h, rd_en_0=%0h, rd_en_1=%0h, rd_en_2=%0h", t.d_in, t.pkt_valid, t.rd_en_0, t.rd_en_1, t.rd_en_2), UVM_NONE);
        finish_item(t);
    endtask
endclass

// Driver
class driver extends uvm_driver #(router_transaction);
    `uvm_component_utils(driver)
    
    virtual router_if vif;
    transaction tr;
    
    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr", this);
        if (!uvm_config_db#(virtual router_if)::get(this, "", "vif", vif))
            `uvm_fatal("router_driver", "Virtual interface not set")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            seq_item_port.get_next_item(tr);
            vif.d_in = tr.d_in;
            vif.pkt_valid = tr.pkt_valid;
            vif.rd_en_0 = tr.rd_en_0;
            vif.rd_en_1 = tr.rd_en_1;
            vif.rd_en_2 = tr.rd_en_2;
            `uvm_info("DRIVER", $sformatf("Received Input: d_in=%0h, pkt_valid=%0h, rd_en_0=%0h, rd_en_1=%0h, rd_en_2=%0h", tr.d_in, tr.pkt_valid, tr.rd_en_0, tr.rd_en_1, tr.rd_en_2), UVM_NONE);
            seq_item_port.item_done();
        end
    endtask
endclass

// Monitor
class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    virtual router_if vif;
    transaction t;
    uvm_analysis_port #(transaction) send;
    
    function new(string name = "mon", uvm_component parent);
        super.new(name, parent);
        send = new("send", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        t = transaction::type_id::create("t");
        if (!uvm_config_db#(virtual router_if)::get(this, "", "vif", vif))
            `uvm_fatal("router_monitor", "Virtual interface not set")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            @(negedge vif.clk);
            #1;
            t.dout_0 = vif.dout_0;
            t.dout_1 = vif.dout_1;
            t.dout_2 = vif.dout_2;
            t.vld_out_0 = vif.vld_out_0;
            t.vld_out_1 = vif.vld_out_1;
            t.vld_out_2 = vif.vld_out_2;
            t.err = vif.err;
            t.busy = vif.busy;
            `uvm_info("MONITOR", $sformatf("Received Output: dout_0=%0h, dout_1=%0h, dout_2=%0h", t.dout_0, t.dout_1, t.dout_2), UVM_NONE);
            send.write(t);
        end
    endtask
endclass

// Scoreboard
class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    transaction tr;
    uvm_analysis_imp #(transaction, scoreboard) recv;
    
    function new(string name = "sco", uvm_component parent);
        super.new(name, parent);
        recv = new("send", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr", this);
    endfunction
    
    virtual function void write(input transaction t);
        tr = t;
        `uvm_info("SCOREBOARD", $sformatf("Received Output: dout_0=%0h, dout_1=%0h, dout_2=%0h", tr.dout_0, tr.dout_1, tr.dout_2), UVM_MEDIUM)
    endfunction
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent);
  uvm_sequencer #(transaction) sqr;
  driver d;
  monitor m;
  function new(string comp = "agent", uvm_component parent = null);
    super.new(comp, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = uvm_sequencer#(transaction)::type_id::create("sqr", this);
    d   = driver::type_id::create("d", this);
    m   = monitor::type_id::create("m", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass

//============================Edit from here===========================//
// Environment
class env extends uvm_env;
    `uvm_component_utils(router_env)
    
    router_driver drv;
    router_monitor mon;
    router_scoreboard sb;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = router_driver::type_id::create("drv", this);
        mon = router_monitor::type_id::create("mon", this);
        sb = router_scoreboard::type_id::create("sb", this);
        mon.mon_ap.connect(sb.sb_ap);
    endfunction
endclass

// Test
class router_test extends uvm_test;
    `uvm_component_utils(router_test)
    
    router_env env;
    router_sequence seq;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = router_env::type_id::create("env", this);
        seq = router_sequence::type_id::create("seq");
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(env.drv.seq_item_port);
        phase.drop_objection(this);
    endtask
endclass

module tb_top;
    logic clk;
    logic rst;

    // Clock generation
    always #5 clk = ~clk;

    // Interface instance
    router_if tb_if (clk, rst);

    // DUT instance
    router DUT (
        .clk(tb_if.clk),
        .rst(tb_if.rst),
        .d_in(tb_if.d_in),
        .pkt_valid(tb_if.pkt_valid),
        .rd_en_0(tb_if.rd_en_0),
        .rd_en_1(tb_if.rd_en_1),
        .rd_en_2(tb_if.rd_en_2),
        .vld_out_0(tb_if.vld_out_0),
        .vld_out_1(tb_if.vld_out_1),
        .vld_out_2(tb_if.vld_out_2),
        .err(tb_if.err),
        .busy(tb_if.busy),
        .dout_0(tb_if.dout_0),
        .dout_1(tb_if.dout_1),
        .dout_2(tb_if.dout_2)
    );

    // Run UVM test
    initial begin
        rst = 1;
        #10 rst = 0;
        run_test("router_test");
    end
endmodule
