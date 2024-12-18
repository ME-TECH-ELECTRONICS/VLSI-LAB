class Generator;
    int loop = 5;
    mailbox drv_mbx;
    event drv_done;

    task run();
        for (int i = 0; i < loop; i++) begin
            Packet item = new();
            item.randomize();
            $display ("[%0tps] Generator: Loop %0d/%0d create new item", $time, i+1, loop);
            drv_mbx.put(item);
            $display ("[%0tps] Generator: Wait for driver to be done", $time);
            @(drv_done);
        end
    endtask 
endclass