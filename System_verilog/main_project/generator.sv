class Generator;
    mailbox #(Packet) mbx;
    event drv_done;
    Packet pkt;
    bit[7:0] header;

    function new(mailbox #(Packet) mbx, event drv_done);
        this.mbx = mbx;
        this.drv_done = drv_done;    
    endfunction

    task run(int loopCount = 1);
        repeat(loopCount) begin 
            pkt = new();
            pkt.parity = 0;
            $display("[%0tps] Generator: Starting....", $time);
            
            pkt.pkt_type = RESET;
            mbx.put(pkt);
            @(drv_done);
            
            if(!pkt.randomize()) $error("Randomization failed");
            pkt.print("Generator");
            pkt.pkt_type = HEADER;
            header = pkt.header;
            pkt.parity = pkt.parity ^ pkt.header;
            pkt.print("Generator");
            mbx.put(pkt);
            @(drv_done);
            
            for (int i = 0; i < header[7:2]; i++) begin
                if(!pkt.randomize()) $error("Randomization failed");
                pkt.print("Generator");
                pkt.parity = pkt.parity ^ pkt.data;
                pkt.pkt_type = PAYLOAD;
                mbx.put(pkt);
                @(drv_done);
            end
            pkt.pkt_type = PARITY;
            pkt.data = pkt.parity;
            mbx.put(pkt);
        end
    endtask


 endclass 