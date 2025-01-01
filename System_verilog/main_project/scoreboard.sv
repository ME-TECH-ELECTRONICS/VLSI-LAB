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
        
    endtask
endclass