class Scoreboard;
    local bit[7:0] header;
    mailbox #(Packet) mbx_in;
    mailbox #(Packet) mbx_out;
    virtual router_if vif;
    bit[7:0] in_stream[], out_stream[];
    logic TX_done = 0;
    logic RX_done = 0;
    
    function new(mailbox #(Packet) mbx_in, mailbox #(Packet) mbx_out);
        this.mbx_in = mbx_in;
        this.mbx_out = mbx_out;
    endfunction
    
    task in_run();
        forever begin
            Packet pkt;
            mbx_in.get(pkt);
            checkPacket(pkt);
        end
    endtask
    
    task out_run();
        int count = 1;
        //int c = 0;
        forever begin
            Packet pkt;
            mbx_out.get(pkt);
            checkPacket_1(pkt);
            if(count >= header[7:2] + 1)
                $display("End of scoreboard");
            else
                count = count + 1;
        end
    endtask
    
    task checkPacket(Packet item);
        if(item.pkt_valid && item.rst) begin
            
            if(item.pkt_type == HEADER) begin
                header = item.data;
                bit[8:0] cnt; 
                cnt = header[7:2] + 2;
                in_stream = new[cnt];
                in_stream.push_back(header);
            end
            if(item.pkt_type == PAYLOAD || item.pkt_type == PARITY) begin
              in_stream.push_back(item.data);
            end
        end
    endtask
    
    task checkPacket_1(Packet item);
        if(item.rd_en_0 && item.dout_0 != 0)
            out_stream.push_back(item.dout_0);
        else if(item.rd_en_1 && item.dout_1 != 0)
            out_stream.push_back(item.dout_1);
        else if(item.rd_en_2 && item.dout_2 != 0)
            out_stream.push_back(item.dout_2);
    endtask
    
    function pushData(Packet item);
        if(item.rd_en_0 || item.rd_en_2 || item.rd_en_2)
            out_stream.push_back(item.dout_0 || item.dout_1 || item.dout_0 );
        
    endfunction
endclass