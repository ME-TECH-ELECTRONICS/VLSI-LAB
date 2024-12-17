
class Monitor;
    virtual adder_intf vif;
    mailbox sbd_mbx;
    
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
        end
    endtask 
endclass 



  
  