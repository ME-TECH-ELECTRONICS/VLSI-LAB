`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
    generator gen;
    driver driv;
    mailbox mbox;
    mailbox mbox_1;
    monitor mon;
    scoreboard sco;
    virtual intf vif;
    function new(virtual intf vif);
        this.vif=vif;
        mbox=new();
        mbox_1=new();
        gen=new(mbox);
        driv=new(vif,mbox);
        mon=new(vif,mbox_1);
        sco=new(mbox_1);
    endfunction
    task test();
        fork
            gen.main();
            driv.main();
            mon.main();
            sco.main();
        join_any
    endtask
    task post_task();
        wait(gen.ended.triggered);
    endtask
    task run();
        test();
        post_task();
        $finish();
    endtask
endclass