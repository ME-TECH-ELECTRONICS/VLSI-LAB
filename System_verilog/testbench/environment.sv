`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "interface.sv"

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
        drv = new(drv_done, drv_mbx, vif);
        mon = new(vif, sbd_mbx);
        sbd = new(sbd_mbx);
    endfunction
    
    task run();
        fork
            gen.run();
            mon.run();
            drv.run();
            sbd.run();
        join_any
    endtask
endclass