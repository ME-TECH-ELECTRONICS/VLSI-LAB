
class Scoreboard;
    mailbox sbd_mbx;
    
    task run();
        forever begin 
            Packet item, ref_item;
            sbd_mbx.get(item);
            ref_item = new();
            ref_item.copy(item);
            
            {ref_item.carry, ref_item.sum} = ref_item.a + ref_item.b;
            
            if(ref_item.carry != item.carry) begin 
                $display("[%0tps] Scoreboard: Error:- Carry mismatch ref_item.carry = %0d, item.carry = %0d", $time, ref_item.carry, item.carry);
            end else begin 
                $display("[%0tps] Scoreboard:  Pass:- Carry match ref_item.carry = %0d, item.carry = %0d", $time, ref_item.carry, item.carry);
            end
            
            if(ref_item.sum != item.sum) begin 
                $display("[%0tps] Scoreboard: Error:- Sum mismatch ref_item.sum = %0d, item.sum = %0d", $time, ref_item.sum, item.sum);
            end else begin 
                $display("[%0tps] Scoreboard: Pass:- Sum match ref_item.sum = %0d, item.sum = %0d", $time, ref_item.sum, item.sum);
            end
        end
    endtask
endclass