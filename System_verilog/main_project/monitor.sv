class Monitor;
    local bit[7:0] header;
    mailbox #(Packet) mbx_in;
    mailbox #(Packet) mbx_out;
    event drv_done;
    virtual router_if vif;
  	int count = 0;
  	int count_1 = 0;

    function new(mailbox #(Packet) mbx_in, mailbox #(Packet) mbx_out, event drv_done, virtual router_if vif);
        this.mbx_in = mbx_in;
        this.mbx_out = mbx_out;
        this.drv_done = drv_done;
        this.vif = vif;
    endfunction

    task run();
        $display("[%0tps] Monitor: Starting...", $time);
     
        forever begin
            checkPacket_in(header);
        end
    endtask


    task checkPacket_in(ref bit[7:0] header);
        Packet item = new();
        if(count < header[7:2] + 1)
      	    @(drv_done);
        @(posedge vif.clk);
        #1;
        item = parsePacket();
        if(!header && item.pkt_valid) begin
            item.pkt_type = HEADER;
            header = item.data;
        end
        else if(header && item.pkt_valid) begin
            item.pkt_type = PAYLOAD;
        end
        else if(header && !item.pkt_valid) begin
            item.pkt_type = PARITY;
            header = 0;
        end
        else begin
            item.pkt_type = RESET;
        end
        item.print("Monitor");
        mbx_in.put(item);
        count = count + 1;
        
    endtask
    
    task checkPacket_out()
        Packet item = new();
        if(count_1 < header[7:2] + 1) begin
            @(posedge vif.clk);
            #1;
            @(posedge vif.rd_en_0 or posedge rd_en_1 or posedge rd_en_2);
            item = parsePacket();
            mbx_out.put(item);
            count_1 = count_1 + 1; 
      	end
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


