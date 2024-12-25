class Driver;
    mailbox mbx;
    event drv_done;
    event headerByte;
    virtual router_if vif;
    virtual router_clk clk_vif;

    function new(mailbox mbx, event drv_done, router_if vif, router_clk clk_vif, event headerByte);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.headerByte = headerByte;
        this.vif = vif;
        this.clk_vif = clk_vif;
    endfunction

    task run();
        $display("[%0tps] Driver: Starting...", $time);
        forever begin
            Payload pld = new();
            header hdr = new();
            @(headerByte);
            @(posedge clk_vif.clk);
            mbx.get(hdr);
            $display("[%0tps] Driver: Recevied header byte.", $time);
            hdr.print("Driver");
            pld.parity = pld.parity ^ hdr.header; 
            pld.pkt_valid = 1;
            vif.pkt_valid = 1;
            vif.data = hdr.header;
            for (int i = 0; i < hdr.len; i++) begin
                mbx.get(pld);
                pld.print("Driver");
                vif.data = pld.data;
                pld.parity = pld.parity ^ pld.data;
                ->drv_done;
                @(posedge clk_vif.clk);
            end
            vif.pkt_valid = 0;
            pld.pkt_valid = 0;
            pld.data = pld.parity;
        end
    endtask
endclass 