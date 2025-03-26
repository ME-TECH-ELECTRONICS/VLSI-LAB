`timescale 1ns / 1ns

module slave (
    input PCLK,         // Clock signal
    PRESETn,            // Active-low reset signal
    input PSEL,         // Peripheral select signal
    PENABLE,            // Enable signal for APB transaction
    PWRITE,             // Read (0) or Write (1) control signal
    input [7:0] PADDR,  // Address bus
    PWDATA,             // Write data bus
    output [7:0] PRDATA, // Read data bus
    output reg PREADY    // Ready signal
);

  reg [7:0] reg_addr;    // Register to store address for read operation
  reg [7:0] mem[0:63];   // Memory array of 64 locations (8-bit each)

  // Assign output read data from memory
  assign PRDATA = mem[reg_addr];

  // APB Slave behavior based on PSEL, PENABLE, and PWRITE signals
  always @(*) begin
    if (!PRESETn) PREADY = 0; // Reset condition
    
    // Setup phase (Read operation): Address is latched
    else if (PSEL && !PENABLE && !PWRITE) begin
      PREADY = 0;
    end 
    
    // Enable phase (Read operation): Provide read data
    else if (PSEL && PENABLE && !PWRITE) begin
      PREADY   = 1;
      reg_addr = PADDR;
    end 
    
    // Setup phase (Write operation): Address and data setup
    else if (PSEL && !PENABLE && PWRITE) begin
      PREADY = 0;
    end 
    
    // Enable phase (Write operation): Write data to memory
    else if (PSEL && PENABLE && PWRITE) begin
      PREADY = 1;
      mem[PADDR] = PWDATA;
    end 
    
    else PREADY = 0; // Default case: Not ready
  end
endmodule
