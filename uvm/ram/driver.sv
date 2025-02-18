class driver extends uvm_driver#(ram_txn);
    `uvm_component_utils(ram_drv)
    virtual ram_if vif;

    function new(string name = "RAM_DRIVER", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ram_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Virtual interface not set")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            transaction txn;
            seq_item_port.get_next_item(txn);
            vif.wr_en = txn.wr_en;                                          
            vif.rd_en = txn.rd_en;
            vif.wr_addr = txn.wr_addr;
            vif.rd_addr = txn.rd_addr;
            vif.din = txn.din;
            seq_item_port.item_done();
        end
    endtask
endclass