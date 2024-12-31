class Monitor;
    local bit[7:0] header;
    mailbox #(Packet) mbx;
    event drv_done;
    virtual router_if vif;
  	int count = 0;

    function new(mailbox #(Packet) mbx, event drv_done, virtual router_if vif);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.vif = vif;
    endfunction

    task run();
        $display("[%0tps] Monitor: Starting...", $time);
     
        forever begin
            checkPacket(count);
            count++;
        end
    endtask

    task checkPacket(ref int counter);
        Packet item = new();
      	@(drv_done);
        @(posedge vif.clk);
        #1;
        item = parsePacket();
        case (counter)
            0 : item.pkt_type = RESET;
            1 : item.pkt_type = HEADER;
            2 : item.pkt_type = PAYLOAD;
            3 : item.pkt_type = PARITY;
            default: counter = 0;
        endcase
        item.print("Monitor");
        mbx.put(item);
        
    endtask

    function Packet parsePacket();
        Packet pkt = new(); 
        pkt.pkt_valid = vif.pkt_valid;
        pkt.data = vif.data;
        pkt.rd_en_0 = vif.rd_en_0;
        pkt.rd_en_1 = vif.rd_en_1;
        pkt.rd_en_2 = vif.rd_en_2;
        pkt.vld_out_0 = vif.vld_out_0;   
        pkt.vld_out_1 = vif.vld_out_1;   
        pkt.vld_out_2 = vif.vld_out_2;   
        pkt.err = vif.err;         
        pkt.busy = vif.busy;        
        pkt.dout_0 = vif.dout_0;
        pkt.dout_1 = vif.dout_1;
        pkt.dout_2 = vif.dout_2;
        return pkt;
    endfunction

endclass 


