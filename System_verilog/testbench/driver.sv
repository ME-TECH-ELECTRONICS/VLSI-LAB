class Driver;
    event drv_done;
    mailbox mbx;
    virtual adder_intf vif;
    
    function new(event drv_done, mailbox mbx, virtual adder_intf vif);
        this.drv_done = drv_done;
        this.mbx = mbx;
        this.vif = vif;
    endfunction
endclass