class Scoreboard;
    local bit[7:0] header;
    mailbox #(Packet) mbx;
    event drv_done;
    virtual router_if vif;
    bit[7:0] in_stream[$], out_stream[$];
    function new(mailbox #(Packet) mbx, event drv_done, virtual router_if vif);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.vif = vif;
    endfunction
    
    task run();
        Packet pkt;
        mbx.get(pkt);
    endtask
    
    task checkPacket(Packet item);
        if(item.pkt_valid && item.rst) begin
            case (pkt.pkt_type)
                HEADER: begin
                    header = item.data;
                    in_stream = new[header[7:0] + 2];
                    out_stream = new[header[7:0] + 2];
                    pushData(item);
                    
                end
                PAYLOAD: drive_payload(pkt);
                PARITY: drive_parity(pkt);
                default: ;
            endcase
            if(item.pkt_type == HEADER) begin
                header = item.data;
                in_stream = new[header[7:0] + 2];
                in_stream.push_back(header);
            end
        end
        
    endtask
    
    function pushData(Packet item);
        if(item.rd_en_0 || item.rd_en_2 || item.rd_en_2)
            out_stream.push_back(item.dout_0 || item.dout_1 || item.dout_0 );
        in_stream.push_back(item.data)
    endfunction
endclass