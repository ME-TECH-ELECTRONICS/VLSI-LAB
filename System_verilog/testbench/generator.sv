class Packet;
    rand bit rst;
    rand bit[7:0] a;
    rand bit[7:0] b;
    bit[7:0] sum;
    bit carry;

    function void print(string id="");
        $display("T: %0t ID: %0s A = %0d B = %0d SUM = %0d CARRY = %0d", $time, id, a, b, sum, carry);
    endfunction
endclass 

class generator;
    int loop = 256;
    mailbox mbx;
    event drv_done;

    task run();
        for (int i = 0; i < loop; i++) begin
            Packet item = new();
            item.randomize();
            $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, i+1, loop);
            mbx.put(item);
            $display ("T=%0t [Generator] Wait for driver to be done", $time);
            @(drv_done);
        end
    endtask 
endclass

class Driver;
    event drv_done;
    mailbox mbx;

    task run();
        $display ("T=%0t [Driver] starting ...", $time);
        forever begin
            Packet item;

            $display ("T=%0t [Driver] waiting for item ...", $time);
            drv_mbx.get(item);
            @ (posedge m_clk_vif.tb_clk);
	        item.print("Driver");
            m_adder_vif.rstn <= item.rstn;
            m_adder_vif.a <= item.a;
            m_adder_vif.b <= item.b;
            ->drv_done;
        end
    endtask
endclass 

module Adder (
    logic 
);
    
endmodule