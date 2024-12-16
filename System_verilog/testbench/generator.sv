class Generator;
    int loop = 5;
    mailbox mbx;
    event drv_done;

    function new(event drv_done, mailbox mbx);
        this.drv_done = drv_done;
        this.mbx = mbx;
    endfunction

    task run();
        for (int i = 0; i < loop; i++) begin
            Packet item = new();
            item.randomize();
            $display ("[%0tps] Generator: Loop %0d/%0d create new item", $time, i+1, loop);
            mbx.put(item);
            $display ("[%0tps] Generator: Wait for driver to be done", $time);
            @(drv_done);
        end
    endtask 
endclass
