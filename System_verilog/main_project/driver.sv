class Driver;
    local bit[7:0] header; // Stores packet header data
    mailbox #(Packet) mbx; // Mailbox for communication with other components
    event drv_done; // Event to signal when driving is done
    virtual router_if vif; // Virtual interface for DUT interaction

  function new(mailbox #(Packet) mbx, event drv_done, virtual router_if vif);
        this.mbx = mbx; // Initialize mailbox
        this.drv_done = drv_done; // Initialize event
        this.vif = vif; // Initialize virtual interface
    endfunction

    task run();
        $display("[%0tps] Driver: Starting...", $time);
        
        forever begin
            Packet pkt = new(); // Create new packet instance
            mbx.get(pkt); // Retrieve packet from mailbox
            drive(pkt); // Drive packet data to DUT
            vif.rd_en_0 = pkt.rd_en_0; // Set read enable signals
            vif.rd_en_1 = pkt.rd_en_1;
            vif.rd_en_2 = pkt.rd_en_2;
            ->drv_done; // Signal driver completion
        end
    endtask

    task drive(Packet pkt);
        case (pkt.pkt_type)
            RESET: reset_dut(); // Handle reset packet
            HEADER: drive_header(pkt); // Handle header packet
            PAYLOAD: drive_payload(pkt); // Handle payload packet
            PARITY: drive_parity(pkt); // Handle parity packet
            default: $display("Invalid packet type"); // Handle invalid packet types
        endcase
    endtask

    task reset_dut();
        vif.rst = 0; // Deassert reset
        @(posedge vif.clk);
        vif.rst = 1; // Assert reset
        vif.pkt_valid = 0; // Deassert packet valid
        @(posedge vif.clk);
    endtask

    task drive_header(Packet pkt);  
        wait(vif.busy == 0); // Wait until DUT is not busy
        @(negedge vif.clk);
        vif.pkt_valid = 1; // Assert packet valid
        vif.data = pkt.header; // Drive header data
        @(posedge vif.clk);
        @(posedge vif.clk);
    endtask

    task drive_payload(Packet pkt);
        wait(vif.busy == 0); // Wait until DUT is not busy
        @(negedge vif.clk);
        vif.pkt_valid <= 1; // Assert packet valid
        vif.data <= pkt.data; // Drive payload data
    endtask
    
    task drive_parity(Packet pkt);
        wait(vif.busy == 0); // Wait until DUT is not busy
        @(negedge vif.clk);
        vif.pkt_valid <= 0; // Deassert packet valid
        vif.data <= pkt.parity; // Drive parity data
    endtask
endclass
