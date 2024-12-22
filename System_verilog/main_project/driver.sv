class driver;
    mailbox mbx;
    event drv_done;
    virtual router_if vif;
    virtual router_clk clk_vif;
    function new(mailbox mbx, event drv_done, router_if vif, router_clk clk_vif);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.vif = vif;
        this.clk_vif = clk_vif;
    endfunction

    task run();
        $display("[%0tps] Driver: Starting...", $time);
        forever begin
            Payload pld = new();
            @(clk_vif.clk);
            $display("[%0tps] Driver: Waiting for input...", $time);
            mbx.get(pld);
            vif.
            ->drv_done;
        end
    endtask
endclass 