class Driver;
    event drv_done;
    mailbox mbx;
    virtual adder_intf vif;
    Packet item;
    
    function new(event drv_done, mailbox mbx, virtual adder_intf vif, Packet item);
        this.drv_done = drv_done;
        this.mbx = mbx;
        this.vif = vif;
        this.item = item;
    endfunction
    
    task run();
        $display("[%0tps] Driver: Starting...", $time);
        forever begin
            Packet item;
            $display("[%0tps] Driver: Waiting for input...", $time);
            mbx.get(item);
            vif.a <= item.a;
            vif.b <= item.b;
            vif.c <= item.c;
            ->drv_done;
        end
        
    endtask
endclass