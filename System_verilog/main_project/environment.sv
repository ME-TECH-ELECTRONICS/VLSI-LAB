
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

    mailbox #(Packet) drv_mbx;
    mailbox #(Packet) sbd_mbx_in;
    mailbox #(Packet) sbd_mbx_out;
    event drv_done;
    virtual router_if vif;

    function new(virtual router_if vif);
        drv_mbx = new();
        sbd_mbx_in = new();
        sbd_mbx_out = new();
        gen = new(drv_mbx, drv_done);
        drv = new(drv_mbx, drv_done, vif);
        mon = new(sbd_mbx_in, sbd_mbx_out, drv_done, vif);
        sbd = new(sbd_mbx_in, sbd_mbx_out);
    endfunction

    task run();
        fork
            gen.run();
            drv.run();
            mon.run();
            mon.run1();
            sbd.in_run();
            sbd.out_run();
        join
    endtask
endclass
