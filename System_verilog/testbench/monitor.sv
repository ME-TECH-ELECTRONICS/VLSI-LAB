class Monitor;
    virtual adder_intf vif;
    virtual clk_intf clk_vif;
    mailbox sbd_mbx;
    event drv_done;

    function new(virtual adder_intf vif,mailbox sbd_mbx, virtual clk_intf clk_vif);
        this.vif = vif;
        this.clk_vif = clk_vif;
        this.sbd_mbx = sbd_mbx;
    endfunction

    task run();
        $display("[%0tps] Monitor: starting...", $time);

        forever begin
            @(posedge clk_vif.clk);
            Packet item = new();  
            item.a = vif.a;
            item.b = vif.b;
            item.sum = vif.sum;
            item.carry = vif.carry;
            item.print("Monitor");
            sbd_mbx.put(item);
            @(drv_done);

        end
    endtask 
endclass 