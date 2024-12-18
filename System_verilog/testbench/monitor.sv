class Monitor;
    virtual adder_intf vif;
    mailbox sbd_mbx;
    event drv_done;

    function new(virtual adder_intf vif,mailbox sbd_mbx);
        this.vif=vif;
        this.sbd_mbx=sbd_mbx;
    endfunction

    task run();
        $display("[%0tps] Monitor: starting...", $time);

        forever begin
            
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