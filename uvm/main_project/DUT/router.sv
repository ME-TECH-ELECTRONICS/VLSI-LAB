/********************************************************/
/*      AUTHOR: METECH                                  */
/*      FILE_NAME: router.sv                             */
/*      DESCRIPTION: Top level module of a 1x3 router   */
/*      DATE: 21/12/2024                                */
/********************************************************/

module router (
    input logic clk,                    // Clock input
    input logic rst,                    // Reset input
    input logic [7:0] d_in,             // Data input (8 bits)
    input logic pkt_valid,              // Packet validity signal
    input logic rd_en_0,                // Read enable for FIFO 0
    input logic rd_en_1,                // Read enable for FIFO 1
    input logic rd_en_2,                // Read enable for FIFO 2
    output logic vld_out_0,             // Valid output for FIFO 0
    output logic vld_out_1,             // Valid output for FIFO 1
    output logic vld_out_2,             // Valid output for FIFO 2
    output logic err,                   // Error signal
    output logic busy,                  // Busy signal indicating processing
    output logic [7:0] dout_0,          // Data output from FIFO 0
    output logic [7:0] dout_1,          // Data output from FIFO 1
    output logic [7:0] dout_2           // Data output from FIFO 2
);

    // Internal wire declarations for FIFO control signals and state management
    logic soft_rst_0, full_0, empty_0; 
    logic soft_rst_1, full_1, empty_1; 
    logic soft_rst_2, full_2, empty_2; 
    logic fifo_full, detect_addr, ld_state, laf_state; 
    logic full_state, lfd_state, rst_int_reg; 
    logic parity_done, low_pkt_valid, wr_en_reg;
    logic [2:0] wr_en;               // Write enable for the FIFOs
    logic [7:0] din;                 // Data input to FIFOs

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
        d_in[1:0], wr_en_reg, 
        detect_addr, ld_state, laf_state, 
        lfd_state, full_state, 
        rst_int_reg, busy
    );

endmodule

