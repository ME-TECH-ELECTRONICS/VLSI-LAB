
class Driver;
    event drv_done;
    mailbox mbx;
    virtual adder_intf vif;
    
    task run();
        $display("[%0tps] Driver: Starting...", $time);
        forever begin
            Packet item = new();
            $display("[%0tps] Driver: Waiting for input...", $time);
            mbx.get(item);
            vif.a <= item.a;
            vif.b <= item.b;
            ->drv_done;
        end
        
    endtask
endclass