/****************************************************/
//      AUTHOR: METECH
//      FILE_NAME: router.v
//      DESCRIPTION: Top level module of a 1x3 router
//      DATE: 08/10/2024
/****************************************************/

module router (
    input clk,                     // Clock input
    input rst,                     // Reset input
    input [7:0] d_in,             // Data input (8 bits)
    input pkt_valid,              // Packet validity signal
    input rd_en_0,                // Read enable for FIFO 0
    input rd_en_1,                // Read enable for FIFO 1
    input rd_en_2,                // Read enable for FIFO 2
    output vld_out_0,             // Valid output for FIFO 0
    output vld_out_1,             // Valid output for FIFO 1
    output vld_out_2,             // Valid output for FIFO 2
    output err,                   // Error signal
    output busy,                  // Busy signal indicating processing
    output [7:0] dout_0,          // Data output from FIFO 0
    output [7:0] dout_1,          // Data output from FIFO 1
    output [7:0] dout_2            // Data output from FIFO 2
);

    // Internal wire declarations for FIFO control signals and state management
    wire soft_rst_0, full_0, empty_0; 
    wire soft_rst_1, full_1, empty_1; 
    wire soft_rst_2, full_2, empty_2; 
    wire fifo_full, detect_addr, ld_state, laf_state; 
    wire full_state, lfd_state, rst_int_reg; 
    wire parity_done, low_pkt_valid, write_enb_reg;
    wire [2:0] wr_en;               // Write enable for the FIFOs
    wire [7:0] din;                 // Data input to FIFOs

    // Instantiate FIFOs
    fifo FIFO_0 (clk, rst, soft_rst_0, wr_en[0], rd_en_0, lfd_state, din, full_0, empty_0, dout_0);
    fifo FIFO_1 (clk, rst, soft_rst_1, wr_en[1], rd_en_1, lfd_state, din, full_1, empty_1, dout_1);
    fifo FIFO_2 (clk, rst, soft_rst_2, wr_en[2], rd_en_2, lfd_state, din, full_2, empty_2, dout_2);

    // Instantiate synchronizer to manage input data and FIFO states
    synchronizer SYNC (
        clk, rst, d_in[1:0], detect_addr, 
        full_0, full_1, full_2, 
        empty_0, empty_1, empty_2, 
        wr_en_reg, rd_en_0, rd_en_1, rd_en_2, 
        wr_en, fifo_full, 
        vld_out_0, vld_out_1, vld_out_2, 
        soft_rst_0, soft_rst_1, soft_rst_2
    );

    // Instantiate registers to store data and manage errors
    register REG_0 (
        clk, rst, pkt_valid, d_in, 
        fifo_full, detect_addr, 
        ld_state, laf_state, full_state, lfd_state, 
        rst_int_reg, din, err, 
        parity_done, low_pkt_valid
    );

    // Instantiate FSM controller to manage router states and operations
    fsm_controller FSM (
        clk, rst, pkt_valid, fifo_full, 
        empty_0, empty_1, empty_2, 
        soft_rst_0, soft_rst_1, soft_rst_2, 
        parity_done, low_pkt_valid, 
        d_in[1:0], wr_en_req, 
        detect_addr, ld_state, laf_state, 
        lfd_state, full_state, 
        rst_int_req, busy
    );

endmodule

module router_tb(); // Testbench for the router

    reg clk = 0;               // Clock signal
    reg rst;                   // Reset signal
    reg pkt_valid;            // Packet validity signal
    reg rd_en_0, rd_en_1, rd_en_2; // Read enable signals for FIFOs
    reg [7:0] din;            // Data input to router
    wire vld_out_0, vld_out_1, vld_out_2; // Valid outputs from FIFOs
    wire err, busy;           // Error and busy signals
    wire [7:0] dout_0, dout_1, dout_2; // Data outputs from FIFOs
    integer i;                // Loop variable for testing
    router dut(clk, rst, din, pkt_valid, rd_en_0, rd_en_1, rd_en_2, vld_out_0, vld_out_1, vld_out_2, err, busy, dout_0, dout_1, dout_2);
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Task for generating a payload of specified length
    task payload_XB;
        input [5:0] len;        // Length of the payload
        input read;             // Read enable flag
        input [1:0] addr;       // Address to write/read from FIFO
        input [7:0] ext_parity; // External parity for the payload
        reg [7:0] header, data; // Header and data variables
        reg [7:0] parity = 0;   // Parity accumulator
        begin
        
            wait(!busy) begin 
                @(negedge clk); // Wait for negative edge of clock
                pkt_valid = 1;  // Indicate packet is valid
                header = {len, addr}; // Create header with length and address
                din = header;   // Load header into data input
                parity = parity ^ header; // Calculate parity
            end
            
            for (i = 0; i < len; i = i + 1) begin 
                @(negedge clk); // Wait for negative edge of clock
                data = ($random) % 256; // Generate random data byte
                din = data;   // Load data into data input
                parity = parity ^ data; // Update parity
            end
            
            wait(!busy) begin 
                @(negedge clk); // Wait for negative edge of clock
                pkt_valid = 0;  // Indicate packet is no longer valid
                din = (ext_parity == 0) ? parity : ext_parity; // Load parity or external parity
            end
            
            if (read) begin
                @(negedge clk); // Wait for negative edge of clock
                rd_en_0 = (addr == 0); // Set read enable for FIFO 0
                rd_en_1 = (addr == 1); // Set read enable for FIFO 1
                rd_en_2 = (addr == 2); // Set read enable for FIFO 2
                wait(dut.FIFO_0.empty); // Wait until FIFO 0 is empty
                @(negedge clk); // Wait for negative edge of clock
                rd_en_0 = 0; // Reset read enable for FIFO 0
                rd_en_1 = 0; // Reset read enable for FIFO 1
                rd_en_2 = 0; // Reset read enable for FIFO 2
            end
        end
    endtask
    
    initial begin
        // Initialize signals
        rst = 0; //Apply reset
        pkt_valid = 0;
        rd_en_0 = 0;
        rd_en_1 = 0;
        rd_en_2 = 0;
        din = 0;
        #10 rst = 1; // De assert reset
        
        // Test cases with different payload lengths and read addresses
        #10 payload_XB(6'd8, 1, 2'b0, 0); // Payload Length = 8Bytes, Address = 0
        #10 payload_XB(6'd16, 1, 2'b1, 0); // Payload Length = 16Bytes, Address = 1
        #10 payload_XB(6'd17, 0, 2'b1, 0); // Payload Length = 16Bytes, Address = 1, Reading Disabled
        #10 payload_XB(6'd16, 0, 2'b10, 8'h28); // Payload Length = 16Bytes, Address = 2, Corrupted packet
    end
    
endmodule