class Scoreboard;
    mailbox mbx;
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction
    
    task run();
        forever begin 
            Packet item, ref_item;
            mbx.get(item);
            ref_item = new();
            ref_item.copy(item);
            
            {ref_item.carry, ref_item.sum} = ref_item.a + ref_item.b;
            if(ref_item.carry != item.carry) begin 
                $display("[%0tps] Scoreboard: Error:- Carry mismatch ref_item.carry = %0d, item.carry = %0d", $time, ref_item.carry, item.carry);
            end
            else begin()
            if(ref_item.sum != item.sum) begin 
                $display("[%0tps] Scoreboard: Error:- Sum mismatch ref_item.sum = %0d, item.sum = %0d", $time, ref_item.sum, item.sum);
            end
        end
    endtask
endclass