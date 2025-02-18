class sequences extends uvm_sequence#(ram_txn);
    `uvm_object_utils(sequences)

    function new(string name = "RAM_SEQUENCE");
        super.new(name);
    endfunction

    task body();
        transaction txn;
        repeat (10) begin
            txn = ram_txn::type_id::create("txn");
            assert(txn.randomize());
            start_item(txn);
            finish_item(txn);
        end
    endtask
endclass