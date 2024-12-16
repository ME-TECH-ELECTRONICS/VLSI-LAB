class Monitor;
    virtual adder_intf vif;
    mailbox mbx
    function new(virtual adder_intf vif, mailbox mbx);
        this.vif = vif;
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
            scb_mbx.put(item);
        end
    endtask 
endclass 



  
  