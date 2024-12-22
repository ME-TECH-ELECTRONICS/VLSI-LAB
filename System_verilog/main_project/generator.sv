 class generator;
    mailbox mbx;
    event drv_done;

    function new(mailbox mbx, event drv_done);
        this.mbx = mbx;
        this.drv_done = drv_done;
    endfunction

    task run();
        Payload pld;
        Header hdr;
        int i;
        for (int i = 0; i < 5; i++) begin
            pld = new();
            hdr = new();
            pld.randomize();
            hdr.randomize();
            pld.print("generator");
            hdr.print("generator");
            mbx.put(pld, hdr);
            @(drv_done);
        end
    endtask
 endclass 