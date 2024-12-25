class Driver;
    local bit[7:0] header;
    mailbox mbx;
    event drv_done;
    event headerByte;
    virtual router_if vif;
    virtual router_clk clk_vif;

  function new(mailbox mbx, event drv_done, virtual router_if vif, virtual router_clk clk_vif, event headerByte);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.headerByte = headerByte;
        this.vif = vif;
        this.clk_vif = clk_vif;
    endfunction

    task run();
        $display("[%0tps] Driver: Starting...", $time);
        forever begin
            Packet pld = new();
          	vif.rst = 1;
            @(!vif.busy)
            @(posedge clk_vif.clk);
            
            mbx.get(header);
            $display("[%0tps] Driver: Recevied header byte.", $time);
            pld.parity = pld.parity ^ header; 
            vif.pkt_valid = 1;
            vif.data = header;
            for (int i = 0; i <= header[7:2]; i++) begin
                mbx.get(pld);
                pld.print("Driver");
                vif.data = pld.data;
                pld.parity = pld.parity ^ pld.data;
                ->drv_done;
                @(posedge clk_vif.clk);
            end
            vif.pkt_valid = 0;
            vif.data = pld.parity;
        end
        
    endtask
endclass 