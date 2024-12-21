/********************************************************/
/*      AUTHOR: METECH                                  */
/*      FILE_NAME: register.sv                           */
/*      DESCRIPTION:  register module                   */
/*      DATE: 21/12/2024                                */
/********************************************************/

module register (
    input logic clk,                // Clock input
    input logic rst,                // Active-low reset signal
    input logic pkt_valid,          // Packet valid signal indicating data validity
    input logic [7:0] din,          // 8-bit data input
    input logic fifo_full,          // Signal indicating if the FIFO is full
    input logic detect_addr,        // Signal for address detection
    input logic ld_state,           // Signal indicating load state is active
    input logic laf_state,          // Signal indicating load after full state
    input logic full_state,         // Signal indicating the full state of the system
    input logiclfd_state,          // Signal indicating load first data state
    input logic rst_int_reg,        // Signal to reset the internal register
    output logic [7:0] dout,    // 8-bit data output
    output logic err,           // Error signal output
    output logic parity_done,   // Parity check completion flag
    output logic low_pkt_valid  // Signal indicating low packet validity
);

  // Internal registers to store data, parity, and intermediate values
  logic [7:0] header, int_reg, int_parity, ext_parity;

  // PARITY DONE LOGIC: Controls when the parity check is marked as done
  always @(posedge clk) begin
    if (!rst) 
      parity_done <= 0;       // Reset parity done flag
    else if (detect_addr) 
      parity_done <= 0;       // Reset if address detection occurs
    else if ((ld_state && (~fifo_full) && (~pkt_valid)) || 
             (laf_state && low_pkt_valid && (~parity_done)))
      parity_done <= 1;       // Set parity done if conditions are met
  end

  // LOW PACKET VALID LOGIC: Manages the `low_pkt_valid` flag
  always @(posedge clk) begin
    if (!rst) 
      low_pkt_valid <= 0;     // Reset low packet valid flag
    else if (rst_int_reg) 
      low_pkt_valid <= 0;     // Reset if internal register is reset
    else if (ld_state && ~pkt_valid) 
      low_pkt_valid <= 1;     // Set if in load state and no valid packet
  end

  // DATA OUT LOGIC: Controls the data output based on various states
  always @(posedge clk) begin
    if (!rst) begin
      dout <= 0;              // Reset data output
      header <= 0;            // Reset header register
      int_reg <= 0;           // Reset internal register
    end else if (detect_addr && pkt_valid && din[1:0] != 2'b11) 
      header <= din;          // Capture header if address is detected and packet is valid
    else if (lfd_state) 
      dout <= header;         // Output header if in load first data state
    else if (ld_state && ~fifo_full) 
      dout <= din;            // Output data if in load state and FIFO is not full
    else if (ld_state && fifo_full) 
      int_reg <= din;         // Store data in internal register if FIFO is full
    else if (laf_state) 
      dout <= int_reg;        // Output internal register data if in load after full state
  end

  // PARITY CALCULATE LOGIC: Computes the internal parity for error checking
  always @(posedge clk) begin
    if (!rst) 
      int_parity <= 0;      // Reset internal parity
    else if (detect_addr) 
      int_parity <= 0;      // Reset if address detection occurs
    else if (lfd_state && pkt_valid) 
      int_parity <= int_parity ^ header; // XOR with header data if packet is valid
    else if (ld_state && pkt_valid && ~full_state) 
      int_parity <= int_parity ^ din; // XOR with data input if in load state
    else 
      int_parity <= int_parity; // Hold current parity value
  end

  // ERROR LOGIC: Checks if there is a parity error
  always @(posedge clk) begin
    if (!rst) 
      err <= 0; // Reset error flag
    else if (parity_done) begin
      if (int_parity == ext_parity) 
        err <= 0; // No error if internal and external parity match
      else 
        err <= 1; // Set error if parities do not match
    end else 
      err <= 0; // Hold error as 0 if parity is not done
  end

  // EXTERNAL PARITY LOGIC: Stores the external parity value
  always @(posedge clk) begin
    if (!rst) 
      ext_parity <= 0; // Reset external parity
    else if (detect_addr) 
      ext_parity <= 0; // Reset if address detection occurs
    else if ((ld_state && !fifo_full && !pkt_valid) || 
             (laf_state && ~parity_done && low_pkt_valid))
      ext_parity <= din; // Store data input as external parity if conditions are met
  end
endmodule
