`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
    Generator gen;
    Driver drv;
    Monitor mon;
    Scoreboard sbd;
    
    mailbox drv_mbx;
    mailbox sbd_mbx;
    event drv_done;
    virtual adder_intf vif;
    
    function new();
        gen = new(drv_done, drv_mbx);
        mon = new(vif, sbd_mbx);
        drv = new(drv_done, drv_mbx, vif);
        sbd = new(sbd_mbx);
    endfunction
endclass