/*********************************************************/
/*      AUTHOR: METECH                                   */
/*      FILE_NAME: generator.sv                          */
/*      DESCRIPTION: Generates input streams             */
/*      DATE: 03/02/2025                                 */
/*********************************************************/

class Generator;
    mailbox #(Packet) mbx; // Mailbox for communication with driver
    event drv_done; // Event to synchronize with driver
    Packet pkt; // Packet instance
    bit[7:0] header; // Header field storage

    function new(mailbox #(Packet) mbx, event drv_done);
        this.mbx = mbx; // Initialize mailbox
        this.drv_done = drv_done; // Initialize event
    endfunction

    task run(int loopCount = 1);
        repeat(loopCount) begin 
            pkt = new(); // Create a new packet instance
            pkt.parity = 0; // Initialize parity bit
            $display("[%0tps] Generator: Starting....", $time);
            
            pkt.pkt_type = RESET; // Send reset packet
            mbx.put(pkt);
            @(drv_done); // Wait for driver to complete
            
            if(!pkt.randomize()) $error("Randomization failed"); // Randomize packet fields
            pkt.pkt_type = HEADER; // Set packet type to HEADER
            header = pkt.header; // Store header value
            pkt.parity = pkt.parity ^ pkt.header; // Compute parity
            mbx.put(pkt); // Send header packet
            @(drv_done);
            
            for (int i = 0; i < header[7:2]; i++) begin // Loop through payload data
                if(!pkt.randomize()) $error("Randomization failed"); // Randomize payload data
                pkt.parity = pkt.parity ^ pkt.data; // Update parity
                pkt.pkt_type = PAYLOAD; // Set packet type to PAYLOAD
                mbx.put(pkt); // Send payload packet
                @(drv_done);
            end
            pkt.pkt_type = PARITY; // Set packet type to PARITY
            pkt.data = pkt.parity; // Store computed parity in data field
            mbx.put(pkt); // Send parity packet
        end
    endtask
endclass
