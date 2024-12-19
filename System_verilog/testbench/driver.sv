class Driver;
    event drv_done;
    mailbox drv_mbx;
    virtual adder_intf vif;
    virtual clk_intf clk_vif;

    function new(virtual adder_intf vif,mailbox drv_mbx, virtual clk_intf clk_vif);
        this.vif = vif;
        this.clk_vif = clk_vif;
        this.drv_mbx = drv_mbx;
    endfunction

    task run();
        $display("[%0tps] Driver: Starting...", $time);
        forever begin
            
            Packet item = new();
          	@(posedge clk_vif.clk);
            $display("[%0tps] Driver: Waiting for input...", $time);
            drv_mbx.get(item);
            vif.a = item.a;
            vif.b = item.b;
            #1;
            ->drv_done;
        end
    endtask
endclass