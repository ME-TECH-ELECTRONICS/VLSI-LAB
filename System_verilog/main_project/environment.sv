
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
// `include "monitor.sv"
// `include "scoreboard.sv"
class Environment;
    Generator gen;
    Driver drv;
    // Monitor mon;
    // Scoreboard sbd;
    
    mailbox #(Packet) drv_mbx;
    // mailbox sbd_mbx;
    event drv_done;
    event headerByte;
    virtual router_if.tb_mod_port router_vif;
    
  function new(virtual router_if.tb_mod_port router_vif);
        drv_mbx = new();
        // sbd_mbx = new();
        gen = new(drv_mbx, drv_done);
        drv = new(drv_mbx, drv_done, router_vif);
        // mon = new(adder_vif, sbd_mbx);
        // sbd = new(sbd_mbx);
    endfunction
    
    task run();
        fork
            gen.run();
            drv.run();
            // mon.run();
            // sbd.run();
        join_any
    endtask
endclass