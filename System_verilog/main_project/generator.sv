 class generator;
    mailbox mbx;
    event drv_done;
    event headerByte;

    function new(mailbox mbx, event drv_done, event headerByte);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.headerByte = headerByte;
    endfunction

    task run();
        Payload pld;
        Header hdr;
        for (int i = 0; i < 5; i++) begin
            pld = new();
            hdr = new();
            if(!pld.randomize()) $error("Payload randomization failed");
            if(!hdr.randomize()) $error("Header randomization failed");
            pld.print("generator");
            hdr.print("generator");
            mbx.put(pld, hdr);
            ->headerByte;
            @(drv_done);
        end
    endtask
 endclass 