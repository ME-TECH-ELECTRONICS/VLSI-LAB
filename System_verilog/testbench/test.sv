interface adder_intf();
    logic[7:0] a;
    logic[7:0] b;
    bit[7:0] sum;
    bit carry;
endinterface

class Packet;
    rand bit[7:0] a, b;
    bit[7:0] sum; 
    bit carry;
    
    function void print(string comp);
        $display("[%0tps] %0s: a=%0d, b=%0d, sum = %0d, carry = %0d", $time, comp, a, b, sum, carry);
    endfunction
    
    function void copy(Packet tmp);
        a = tmp.a;
        b = tmp.b;
        sum = tmp.sum;
        carry = tmp.carry;
    endfunction
endclass

class Generator;
    int loop = 5;
    mailbox drv_mbx;
    event drv_done;

    task run();
        for (int i = 0; i < loop; i++) begin
            Packet item = new();
            item.randomize();
            $display ("[%0tps] Generator: Loop %0d/%0d create new item", $time, i+1, loop);
            drv_mbx.put(item);
            $display ("[%0tps] Generator: Wait for driver to be done", $time);
            @(drv_done);
        end
    endtask 
endclass


class Driver;
    event drv_done;
    mailbox drv_mbx;
    virtual adder_intf vif;
    
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

class Monitor;
    virtual adder_intf vif;
    mailbox sbd_mbx;
    event drv_done;
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

class Scoreboard;
    mailbox sbd_mbx;
    event drv_done;
    
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

class Environment;
    Generator gen;
    Driver drv;
    Monitor mon;
    Scoreboard sbd;
    
    mailbox drv_mbx;
    mailbox sbd_mbx;
    event drv_done;
    virtual adder_intf adder_vif;
    
    function new();
        gen = new();
        drv = new();
        mon = new();
        sbd = new();
        drv_mbx = new();
        sbd_mbx = new();
    endfunction
    
    task run();
        gen.drv_done = drv_done;
        drv.drv_done = drv_done;
        mon.drv_done = drv_done;
        
        gen.drv_mbx = drv_mbx;
        drv.drv_mbx = drv_mbx;
        
        mon.sbd_mbx = sbd_mbx;
        sbd.sbd_mbx = sbd_mbx;
        
        drv.vif = adder_vif;
        mon.vif = adder_vif;
        
        fork
            gen.run();
            mon.run();
            drv.run();
            sbd.run();
        join_any
    endtask
endclass

module tb();
    adder_intf intf();
    Environment env = new();
    adder_8bit dut(intf);
    
    initial begin 
        env.adder_vif= intf;
        env.run();
        #50 $finish;
    end
endmodule
