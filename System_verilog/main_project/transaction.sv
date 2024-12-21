class Payload;
    rand bit[7:0] data;
    rand bit pkt_valid;
    rand bit rd_en_0;
    rand bit rd_en_1;
    rand bit rd_en_2;
    bit vld_out_0;   
    bit vld_out_1;   
    bit vld_out_2;   
    bit err;         
    bit busy;        
    bit [7:0] dout_0;
    bit [7:0] dout_1;
    bit [7:0] dout_2;

    function void print(string comp);
        $display("[%0tps] %0s: Data = 0x%0h, pkk_valid = %0b, rd_en_0 = %0b, rd_en_1 = %0b, rd_en_2 = %0b, vld_out_0 = %0b, vld_out_1 = %0b, vld_out_2 = %0b, err = %0b, busy = %0b, dout_0 = 0x%0h, dout_1 = 0x%0h, dout_2 = 0x%0h", $time, comp, data, pkt_valid, rd_en_0, rd_en_1, rd_en_2, vld_out_0, vld_out_1, vld_out_2, err, busy, dout_0, dout_1, dout_2);
    endfunction
    
     function void copy(Payload tmp);
        data = tmp.data;
        pkt_valid = tmp.pkt_valid;
        rd_en_0 = tmp.rd_en_0;
        rd_en_1 = tmp.rd_en_1;
        rd_en_2 = tmp.rd_en_2;
        vld_out_0 = tmp.vld_out_0;
        vld_out_1 = tmp.vld_out_1;
        vld_out_2 = tmp.vld_out_2;
        err = tmp.err;
        busy = tmp.busy;
        dout_0 = tmp.dout_0;
        dout_1 = tmp.dout_1;
        dout_2 = tmp.dout_2;
    endfunction

endclass

class Header;
    rand bit[1:0] addr;
    rand bit[5:0] len;
    bit[7:0] header;
    constraint con1 { addr inside {0, 1, 2}; }

    function void post_randomize();
        header = {len, addr};
    endfunction

    function void print(string comp);
        $display("[%0tps] %0s: addr = %0b, len = %0b", $time, comp, addr, len);
    endfunction

endclass