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
        Packet pld = new();
        if(!pld.randomize()) $error("Packet randomization failed");
        pld.print("generator");
        mbx.put(pld.header);
      #3;
        ->headerByte;
        for (int i = 0; i <= pld.header[7:2]; i++) begin
            if(!pld.randomize()) $error("Payload randomization failed");
            pld.print("generator");
            mbx.put(pld);
            @(drv_done);
        end
    endtask


 endclass 