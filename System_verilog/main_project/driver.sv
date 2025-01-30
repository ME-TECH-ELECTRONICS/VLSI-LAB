class Driver;
    local bit[7:0] header;
    mailbox #(Packet) mbx;
    event drv_done;
    virtual router_if vif;

  function new(mailbox #(Packet) mbx, event   drv_done, virtual router_if vif);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.vif = vif;
    endfunction

    task run();
        $display("[%0tps] Driver: Starting...", $time);
        
        forever begin
            Packet pkt = new();
            mbx.get(pkt);
            drive(pkt);
            vif.rd_en_0 = pkt.rd_en_0;
            vif.rd_en_1 = pkt.rd_en_1;
            vif.rd_en_2 = pkt.rd_en_2;
            ->drv_done;
        end
    endtask

    task drive(Packet pkt);
        case (pkt.pkt_type)
            RESET: reset_dut();
            HEADER: drive_header(pkt);
            PAYLOAD: drive_payload(pkt);
            PARITY: drive_parity(pkt);
            default: $display("Invalid packet type");
        endcase
    endtask

    task reset_dut();
        vif.rst = 0;
        @(posedge vif.clk);
        vif.rst = 1;
        vif.pkt_valid = 0;
        @(posedge vif.clk);
    endtask

    task drive_header(Packet pkt);
//         pkt.print("Driver");
        $display("[%0tps] Driver: Sending header byte.", $time);
       
        wait(vif.busy == 0);
        @(negedge vif.clk);
        vif.pkt_valid = 1;
        vif.data = pkt.header;
        @(posedge vif.clk);
        @(posedge vif.clk);
    endtask

    task drive_payload(Packet pkt);
//         pkt.print("Driver");
        $display("[%0tps] Driver: Sending payload byte.", $time);
       
        wait(vif.busy == 0);
        @(negedge vif.clk);
        vif.pkt_valid <= 1;
        vif.data <= pkt.data;
    endtask
    
    task drive_parity(Packet pkt);
//         pkt.print("Driver");
        $display("[%0tps] Driver: Sending parity byte.", $time);
        
        wait(vif.busy == 0);
        @(negedge vif.clk);
        vif.pkt_valid <= 0;
        vif.data <= pkt.parity;
    endtask
endclass 