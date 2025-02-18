class transaction extends uvm_sequence_item;
    rand bit rd_en, wr_en;
    rand bit [3:0] wr_addr, rd_addr;
    rand bit [7:0] din;
    bit [7:0] dout;

    `uvm_object_utils(transaction)

    constraint valid_wr_rd { wr_en != rd_en; }

    function new(string name = "RAM_TRANSACTION");
        super.new(name);
    endfunction
endclass