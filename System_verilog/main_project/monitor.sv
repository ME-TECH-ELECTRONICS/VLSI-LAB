class Monitor;
    local bit[7:0] header = 0; // Stores the header value
    mailbox #(Packet) mbx_in; // Mailbox for storing incoming packets
    mailbox #(Packet) mbx_out; // Mailbox for storing outgoing packets
    event drv_done; // Event to synchronize with the driver
    virtual router_if vif; // Virtual interface for communication with DUT
    int count = 0; // Counter for incoming packets
    int prev_val = 0; // Stores previous output value to detect changes
  
    function new(mailbox #(Packet) mbx_in, mailbox #(Packet) mbx_out, event drv_done, virtual router_if vif);
        this.mbx_in = mbx_in; // Initialize input mailbox
        this.mbx_out = mbx_out; // Initialize output mailbox
        this.drv_done = drv_done; // Initialize event
        this.vif = vif; // Initialize virtual interface
    endfunction

    task run();
        $display("[%0tps] Monitor: Starting...", $time);
        
        forever begin
            checkPacket_in(header); // Check incoming packets
        end
    endtask

    task run1();
        checkPacket_out(); // Check outgoing packets
    endtask

    task checkPacket_in(ref bit[7:0] header);
        Packet item = new(); // Create a new packet instance
        @(drv_done); // Wait for driver completion
        @(posedge vif.clk);
        #1;
        item = parsePacket(); // Parse packet data from interface
        
        if(!header && item.pkt_valid) begin
            item.pkt_type = HEADER; // Identify header packet
            header = item.data;
        end
        else if(header && item.pkt_valid) begin
            item.pkt_type = PAYLOAD; // Identify payload packet
        end
        else if(header && !item.pkt_valid) begin
            item.pkt_type = PARITY; // Identify parity packet
        end
        else begin
            item.pkt_type = RESET; // Identify reset packet
        end
        
        mbx_in.put(item); // Store packet in input mailbox
        count = count + 1; // Increment packet count
    endtask
    
    task checkPacket_out();
        int count_1 = 0;
        Packet item = new(); // Create a new packet instance
        
        while(count_1 < header[7:2] + 1) begin // Process expected number of packets
            @(posedge vif.clk);
            #1; 
            wait(vif.rd_en_0 || vif.rd_en_1 || vif.rd_en_2); // Wait for read enable signals
            
            item = parsePacket(); // Parse packet data from interface
            
            if(item.rd_en_0 && (item.dout_0 != 0) && (prev_val != item.dout_0)) begin
                mbx_out.put(item); // Store packet in output mailbox
                count_1 = count_1 + 1; // Increment processed packet count
                prev_val = item.dout_0; // Update previous value
            end
            else if(item.rd_en_1 && (item.dout_1 != 0) && (prev_val != item.dout_1)) begin
                mbx_out.put(item);
                count_1 = count_1 + 1;
                prev_val = item.dout_1;
            end
            else if (item.rd_en_2 && (item.dout_2 != 0) && (prev_val != item.dout_2)) begin
                mbx_out.put(item);
                count_1 = count_1 + 1;
                prev_val = item.dout_2;
            end else begin
                count_1 = count_1; // Maintain count if no new data
            end
        end
    endtask

    function Packet parsePacket();
        Packet pkt = new(); // Create a new packet instance
        pkt.rst = vif.rst;
        pkt.pkt_valid = vif.pkt_valid;
        pkt.data = vif.data;
        pkt.rd_en_0 = vif.rd_en_0;
        pkt.rd_en_1 = vif.rd_en_1;
        pkt.rd_en_2 = vif.rd_en_2;
        pkt.vld_out_0 = vif.vld_out_0;   
        pkt.vld_out_1 = vif.vld_out_1;   
        pkt.vld_out_2 = vif.vld_out_2;   
        pkt.err = vif.err;         
        pkt.busy = vif.busy;        
        pkt.dout_0 = vif.dout_0;
        pkt.dout_1 = vif.dout_1;
        pkt.dout_2 = vif.dout_2;
        return pkt; // Return parsed packet
    endfunction

endclass
