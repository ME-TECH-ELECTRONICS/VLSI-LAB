/*********************************************************/
/*      AUTHOR: METECH                                   */
/*      FILE_NAME: fifo.sv                               */
/*      DESCRIPTION:  16x9 Fifo Module                   */
/*      DATE: 21/12/2024                                 */
/*********************************************************/

module fifo (
    input logic clk,             // Clock input signal
    input logic rst,             // Active-low reset signal
    input logic soft_reset,      // Soft reset signal to clear certain outputs
    input logic wr_en,           // Write enable signal
    input logic rd_en,           // Read enable signal
    input logic lfd_state,       // State indicating the first data word (header)
    input logic [7:0] din,       // 8-bit input data to write into the FIFO
    output logic full,           // Full flag indicating the FIFO is full
    output logic empty,          // Empty flag indicating the FIFO is empty
    output logic [7:0] dout  // 8-bit output data from the FIFO
);

  logic [4:0] rd_ptr, wr_ptr;    // Read and write pointers (5 bits to track overflow)
  logic [6:0] intCount;          // Counter for tracking multi-byte packet size
  logic [8:0] mem[15:0];         // Memory array with 9-bit width for data + header bit                   // 
  logic lfd_state_t;             // Temporary register to hold the lfd_state signal

  // Latching lfd_state signal with each clock cycle
  always @(posedge clk) begin
    if (!rst) 
      lfd_state_t <= 0;        // Reset lfd_state_t when reset is active
    else 
      lfd_state_t <= lfd_state; // Store the current lfd_state value
  end

  // Managing data output based on read enable and empty status
  always @(posedge clk) begin
    if (!rst) 
      dout <= 8'b0;            // Reset dout to 0 on reset
    else if (soft_reset) 
      dout <= 8'bz;            // Set dout to high impedance on soft reset
    else if (rd_en && !empty) 
      dout <= mem[rd_ptr[3:0]][7:0]; // Read data from memory if enabled and not empty
    else if (intCount == 0) 
      dout <= 8'bz;            // High impedance when no data to output
  end

  // Memory write logic: Writing input data into the FIFO
  always @(posedge clk) begin
    if (!rst || soft_reset) begin
      // Reset all memory locations on reset or soft reset
      for (int i = 0; i < 16; i = i + 1) 
        mem[i] <= 0;
    end else if (wr_en && !full) begin
      // Write data into memory if write enabled and not full
      if (lfd_state_t) begin
        mem[wr_ptr[3:0]][8] <= 1'b1;  // Mark as header word
        mem[wr_ptr[3:0]][7:0] <= din; // Store input data
      end else begin
        mem[wr_ptr[3:0]][8] <= 1'b0;  // Mark as regular data word
        mem[wr_ptr[3:0]][7:0] <= din; // Store input data
      end
    end
  end

  // Write pointer update logic
  always @(posedge clk) begin
    if (!rst) 
      wr_ptr <= 0;             // Reset write pointer
    else if (wr_en && !full) 
      wr_ptr <= wr_ptr + 1;    // Increment write pointer on write enable
  end

  // Read pointer update logic
  always @(posedge clk) begin
    if (!rst) 
      rd_ptr <= 0;             // Reset read pointer
    else if (rd_en && !empty) 
      rd_ptr <= rd_ptr + 1;    // Increment read pointer on read enable
  end

  // Internal counter management for tracking data packets
  always @(posedge clk) begin
    if (rd_en && !empty) begin
      // If header word, initialize intCount with data size + 1
      if (mem[rd_ptr[3:0]][8] == 1'b1) 
        intCount <= mem[rd_ptr[3:0]][7:2] + 1'b1;
      // Otherwise, decrement intCount if it's not zero
      else if (intCount != 0) 
        intCount <= intCount - 1'b1;
    end
  end

  // Full flag: Set when write and read pointers overlap with different MSBs
  assign full = (wr_ptr == {~rd_ptr[4], rd_ptr[3:0]});

  // Empty flag: Set when write and read pointers are identical
  assign empty = (rd_ptr == wr_ptr);

endmodule
