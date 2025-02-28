

`include "uvm_macros.svh"
import uvm_pkg::*;

interface router_if(input logic clk, input logic rst);
    logic [7:0] d_in;
    logic pkt_valid;
    logic rd_en_0, rd_en_1, rd_en_2;
    logic vld_out_0, vld_out_1, vld_out_2;
    logic err, busy;
    logic [7:0] dout_0, dout_1, dout_2;

    modport DUT (
        input clk, rst, d_in, pkt_valid, rd_en_0, rd_en_1, rd_en_2,
        output vld_out_0, vld_out_1, vld_out_2, err, busy, dout_0, dout_1, dout_2
    );

    modport TB (
        input clk, rst,
        output d_in, pkt_valid, rd_en_0, rd_en_1, rd_en_2,
        input vld_out_0, vld_out_1, vld_out_2, err, busy, dout_0, dout_1, dout_2
    );
endinterface


// Transaction class
class router_transaction extends uvm_sequence_item;
    rand logic [7:0] d_in;
    rand logic pkt_valid;
    rand logic rd_en_0, rd_en_1, rd_en_2;
    
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
    
    function new(string name = "router_transaction");
        super.new(name);
    endfunction
endclass

// Generator (Sequence)
class router_sequence extends uvm_sequence #(router_transaction);
    `uvm_object_utils(router_sequence)
    
    function new(string name = "router_sequence");
        super.new(name);
    endfunction
    
    task body();
        router_transaction req;
        req = router_transaction::type_id::create("req");
        start_item(req);
        assert(req.randomize());
        finish_item(req);
    endtask
endclass

// Driver
class router_driver extends uvm_driver #(router_transaction);
    `uvm_component_utils(router_driver)
    
    virtual router_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual router_if)::get(this, "", "vif", vif))
            `uvm_fatal("router_driver", "Virtual interface not set")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            router_transaction tr;
            seq_item_port.get_next_item(tr);
            vif.d_in = tr.d_in;
            vif.pkt_valid = tr.pkt_valid;
            vif.rd_en_0 = tr.rd_en_0;
            vif.rd_en_1 = tr.rd_en_1;
            vif.rd_en_2 = tr.rd_en_2;
            seq_item_port.item_done();
        end
    endtask
endclass

// Monitor
class router_monitor extends uvm_monitor;
    `uvm_component_utils(router_monitor)
    
    virtual router_if vif;
    uvm_analysis_port #(router_transaction) mon_ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
        if (!uvm_config_db#(virtual router_if)::get(this, "", "vif", vif))
            `uvm_fatal("router_monitor", "Virtual interface not set")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            router_transaction tr = router_transaction::type_id::create("tr");
            tr.dout_0 = vif.dout_0;
            tr.dout_1 = vif.dout_1;
            tr.dout_2 = vif.dout_2;
            tr.vld_out_0 = vif.vld_out_0;
            tr.vld_out_1 = vif.vld_out_1;
            tr.vld_out_2 = vif.vld_out_2;
            tr.err = vif.err;
            tr.busy = vif.busy;
            mon_ap.write(tr);
        end
    endtask
endclass

// Scoreboard
class router_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(router_scoreboard)
    
    uvm_analysis_imp #(router_transaction, router_scoreboard) sb_ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_ap = new("sb_ap", this);
    endfunction
    
    virtual function void write(router_transaction tr);
        `uvm_info("SCOREBOARD", $sformatf("Received Output: dout_0=%0h, dout_1=%0h, dout_2=%0h", tr.dout_0, tr.dout_1, tr.dout_2), UVM_MEDIUM)
    endfunction
endclass

// Environment
class router_env extends uvm_env;
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
