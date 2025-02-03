/************************************************************************************/
/*      AUTHOR: METECH                                                              */
/*      FILE_NAME: scoreboard.sv                                                    */
/*      DESCRIPTION: Verifies design using the received output and golden reference */
/*      DATE: 03/02/2025                                                            */
/************************************************************************************/

class Scoreboard;
    bit[7:0] header = 0; // Stores the packet header
    mailbox #(Packet) mbx_in; // Mailbox for input packets
    mailbox #(Packet) mbx_out; // Mailbox for output packets
    virtual router_if vif; // Virtual interface for router
    bit[7:0] in_stream[$], out_stream[$]; // Queues to store input and output data streams
    logic TX_done = 0; // Transmission done flag
    logic RX_done = 0; // Reception done flag
    int prev_val = 0; // Stores previous value to prevent duplicates
    
    // Constructor: Initializes mailboxes
    function new(mailbox #(Packet) mbx_in, mailbox #(Packet) mbx_out);
        this.mbx_in = mbx_in;
        this.mbx_out = mbx_out;
    endfunction
    
    // Task to process incoming packets
    task in_run();
        $display("[%0tps] Scoreboard: Starting...", $time);
        forever begin
            Packet pkt;
            if(mbx_in.num() > 0) begin
                mbx_in.get(pkt);
                checkPacket(pkt, this.header);
            end else begin
                #10; // Wait to avoid busy-waiting
            end
        end
    endtask
    
    // Task to process outgoing packets
    task out_run();
        int count = 1;
        forever begin
            Packet pkt;
            if (mbx_out.num() > 0) begin
                mbx_out.get(pkt);
                checkPacket_1(pkt);
                checkall();
                if (!(count > header[7:2] + 1)) begin
                   count = count + 1;
                end
            end else begin
                #10; // Prevent busy-waiting
            end
        end
    endtask
    
    // Task to check incoming packets and store them
    task checkPacket(Packet item, ref bit[7:0] header);
        bit[8:0] cnt; 
        if(item.pkt_valid && item.rst) begin
            if(item.pkt_type == HEADER) begin
                header = item.data;
                cnt = header[7:2] + 2;
                in_stream.push_back(header);
            end
            if(item.pkt_type == PAYLOAD || item.pkt_type == PARITY) begin
                in_stream.push_back(item.data);
            end
        end
    endtask
   
    // Task to check outgoing packets and store them
    task checkPacket_1(Packet item);
        if(item.rd_en_0 && (item.dout_0 != 0) && (prev_val != item.dout_0)) begin
            out_stream.push_back(item.dout_0);
            prev_val = item.dout_0;
        end
        else if(item.rd_en_1 && (item.dout_1 != 0) && (prev_val != item.dout_1)) begin
            out_stream.push_back(item.dout_1);   
            prev_val = item.dout_1;
        end
        else if(item.rd_en_2 && (item.dout_2 != 0) && (prev_val != item.dout_2)) begin
            out_stream.push_back(item.dout_2);
            prev_val = item.dout_2;
        end
    endtask
     
    // Task to compare input and output streams for verification
    task checkall();
        int in_parity = 0;
        int out_parity = 0;
        if((in_stream.size() == header[7:2] + 1) && (out_stream.size() == header[7:2] + 1)) begin
            
            foreach(in_stream[i]) begin
                in_parity = in_parity ^ in_stream[i];
            end
            in_stream.push_back(in_parity);
            
            foreach(out_stream[i]) begin
                out_parity = out_parity ^ out_stream[i];
            end
            out_stream.push_back(out_parity);
            
            if(in_parity == out_parity) begin
                $display("/******************************************************************************************/");
                $display("/* Successfully verified Router 1x3");
                $display("/* Input: %0p", in_stream);
                $display("/* Output: %0p", out_stream);
                $display("/******************************************************************************************/");
            end
            else begin
                $display("Verification unsuccessful: in_parity = %0h, out_parity = %0h", in_parity, out_parity);
            end
        end
    endtask
endclass
