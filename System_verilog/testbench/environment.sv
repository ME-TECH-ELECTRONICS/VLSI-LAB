

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