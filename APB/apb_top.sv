`timescale 1ns / 1ns

`include "master.sv" // Include Master Bridge module
`include "slave.sv"  // Include Slave module

module APB_Protocol (
    input PCLK,             // Clock signal
    PRESETn,                // Active-low reset signal
    transfer,               // Transfer enable signal
    READ_WRITE,             // Read (1) or Write (0) control signal
    input [8:0] apb_write_paddr, // APB write address
    input [7:0] apb_write_data,  // Data to be written
    input [8:0] apb_read_paddr,  // APB read address
    output PSLVERR,         // Slave error signal
    output [7:0] apb_read_data_out // Read data output
);

  // Internal signals
  wire [7:0] PWDATA, PRDATA, PRDATA1, PRDATA2; // Data buses
  wire [8:0] PADDR; // Address bus

  wire PREADY, PREADY1, PREADY2, PENABLE, PSEL1, PSEL2, PWRITE; // Control signals

  // Select appropriate ready signal based on address MSB
  assign PREADY = PADDR[8] ? PREADY2 : PREADY1;
  
  // Select appropriate read data based on address MSB when READ_WRITE is asserted
  assign PRDATA = READ_WRITE ? (PADDR[8] ? PRDATA2 : PRDATA1) : 8'dx;

  // Instantiate the Master Bridge module
  master_bridge dut_mas (
    apb_write_paddr,   // Write address
    apb_read_paddr,    // Read address
    apb_write_data,    // Write data
    PRDATA,            // Read data
    PRESETn,           // Reset signal
    PCLK,              // Clock signal
    READ_WRITE,        // Read/Write control
    transfer,          // Transfer enable
    PREADY,            // Ready signal
    PSEL1,             // Select signal for Slave 1
    PSEL2,             // Select signal for Slave 2
    PENABLE,           // Enable signal
    PADDR,             // Address bus
    PWRITE,            // Write enable signal
    PWDATA,            // Write data bus
    apb_read_data_out, // Read data output
    PSLVERR            // Slave error signal
  );

  // Instantiate Slave 1
  slave dut1 (
    PCLK,          // Clock signal
    PRESETn,       // Reset signal
    PSEL1,         // Select signal for Slave 1
    PENABLE,       // Enable signal
    PWRITE,        // Write enable signal
    PADDR[7:0],    // Address bus (lower 8 bits)
    PWDATA,        // Write data bus
    PRDATA1,       // Read data output
    PREADY1        // Ready signal
  );

  // Instantiate Slave 2
  slave dut2 (
    PCLK,          // Clock signal
    PRESETn,       // Reset signal
    PSEL2,         // Select signal for Slave 2
    PENABLE,       // Enable signal
    PWRITE,        // Write enable signal
    PADDR[7:0],    // Address bus (lower 8 bits)
    PWDATA,        // Write data bus
    PRDATA2,       // Read data output
    PREADY2        // Ready signal
  );

endmodule
