
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class Environment;
    Generator gen;
    Driver drv;
    Monitor mon;
    Scoreboard sbd;
    
    mailbox drv_mbx;
    mailbox sbd_mbx;
    event drv_done;
    virtual adder_intf adder_vif;
    virtual clk_intf clk_vif;
    
  function new(virtual adder_intf adder_vif, virtual clk_intf clk_vif);
        drv_mbx = new();
        sbd_mbx = new();
        gen = new(drv_mbx);
        drv = new(adder_vif, drv_mbx, clk_vif);
        mon = new(adder_vif, sbd_mbx, clk_vif);
    sbd = new(sbd_mbx);
    endfunction
    
    task run();
        gen.drv_done = drv_done;
        drv.drv_done = drv_done;
        mon.drv_done = drv_done;
        
        fork
            gen.run();
            mon.run();
            drv.run();
            sbd.run();
        join_any
    endtask
endclass