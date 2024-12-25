 class Generator;
    mailbox mbx;
    event drv_done;
    event headerByte;

    function new(mailbox mbx, event drv_done, event headerByte);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.headerByte = headerByte;
    endfunction

    task run();
        Payload pld = new();
        Header hdr = new();
        if(!hdr.randomize()) $error("Header randomization failed");
        hdr.print("generator");
        mbx.put(hdr);
        ->headerByte;
        for (int i = 0; i <= hdr.len; i++) begin
            if(!pld.randomize()) $error("Payload randomization failed");
            pld.print("generator");
            mbx.put(pld, hdr);
            @(drv_done);
        end
    endtask


 endclass 