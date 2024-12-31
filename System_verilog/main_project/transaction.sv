typedef enum logic[1:0]{RESET = 0, HEADER = 1, PAYLOAD = 2, PARITY = 3} pkt_type_t;

class Packet;
    rand bit[7:0] header;
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
    logic[7:0] parity;
    pkt_type_t pkt_type;

    constraint con1 { 
        header[1:0] != 2'b11; 
        header[7:2] != 0; 
    }

    function void print(string comp);
        $display("[%0tps] %0s: Data = 0x%0h, pkk_valid = %0b, rd_en = [%0b, %0b, %0b], vld_out = [%0b, %0b, %0b], err = %0b, busy = %0b, dout = [0x%0h, 0x%0h, 0x%0h], parity = 0x%0h, pkt_type = %0d", $time, comp, data, pkt_valid, rd_en_2, rd_en_1, rd_en_0, vld_out_0, vld_out_1, vld_out_2, err, busy, dout_2, dout_1, dout_1, parity, pkt_type);
    endfunction
    
  function void copy(Packet tmp);
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
        parity = tmp.parity;
    endfunction

endclass
