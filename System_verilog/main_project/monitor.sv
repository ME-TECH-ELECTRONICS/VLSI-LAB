class Monitor;
    virtual adder_intf vif;
    virtual clk_intf clk_vif;
    mailbox mbx;
    event drv_done;

    function new(virtual adder_intf vif,mailbox mbx, virtual clk_intf clk_vif);
        this.vif = vif;
        this.clk_vif = clk_vif;
        this.mbx = mbx;
    endfunction

    task run();
        $display("[%0tps] Monitor: starting...", $time);

        forever begin
            Payload pld = new();
            
            @(posedge clk_vif.clk);
            $display("[%0tps] Monitor: Starting...", $time);
            pld.pkk_valid = vif.pkk_valid;
            hdr.header = vif.data;
            pld.parity = pld.parity ^ hdr.header;
            mbx.put(hdr);
            hdr.print("Monitor");
            hdr.len = hdr.header[7:2];
            for (int i = 0; i < hdr.len; i++) begin
                @(posedge clk_vif.clk);
                pld.data = vif.data;
                pld.parity = pld.parity ^ pld.data;
                pld.rd_en_0 = vif.rd_en_0;
                pld.rd_en_1 = vif.rd_en_1;
                pld.rd_en_2 = vif.rd_en_2;
                pld.vld_out_0 = vif.vld_out_0;
                pld.vld_out_1 = vif.vld_out_1;
                pld.vld_out_2 = vif.vld_out_2;
                pld.err = vif.err;
                pld.busy = vif.busy;
                pld.dout_0 = vif.dout_0;
                pld.dout_1 = vif.dout_1;
                pld.dout_2 = vif.dout_2;
                mbx.put(pld);
                pld.print("Monitor");
                @(drv_done);
            end

        end
    endtask
endclass 