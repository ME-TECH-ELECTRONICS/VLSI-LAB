 class Generator;
    mailbox #(Packet) mbx;
    event drv_done;
    Packet pkt;

    function new(mailbox mbx, event drv_done);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.headerByte = headerByte;
        pkt = new();
    endfunction

    task run();
        $display("[%0tps] Generator: Starting....", $time);
        assert(pld.randomize());
        pkt.print("Generator");
        pkt.pkt_type = HEADER;
        pkt.parity = pkt.parity ^ pkt.header;
        mbx.put(pld);
        #1;
        for (int i = 0; i < pld.header[7:2]; i++) begin
            assert(pld.randomize());
            pld.print("Generator");
            pld.parity = pld.parity ^ pld.data;
            pld.pkt_type = PAYLOAD;
            mbx.put(pld);
            @(drv_done);
        end

    endtask


 endclass 