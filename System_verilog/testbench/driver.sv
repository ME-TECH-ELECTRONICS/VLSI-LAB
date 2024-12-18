class Driver;
    event drv_done;
    mailbox drv_mbx;
    virtual adder_intf vif;
    function new(virtual adder_intf vif,mailbox drv_mbx);
        this.vif=vif;
        this.drv_mbx=drv_mbx;
    endfunction

    task run();
        $display("[%0tps] Driver: Starting...", $time);
        forever begin
            Packet item = new();
            $display("[%0tps] Driver: Waiting for input...", $time);
            drv_mbx.get(item);
            vif.a = item.a;
            vif.b = item.b;
            #1;
            ->drv_done;
        end
    endtask
endclass