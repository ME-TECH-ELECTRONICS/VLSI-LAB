`timescale 1ns/1ps
`include "apb_top.sv"
module apb_tb;
  // Clock and reset signals
  logic PCLK, RST_N;
  
  // Master Inputs
  logic TX, APB_SWRITE;
  logic [8:0] APB_SLV_PADDR;
  logic [7:0] APB_PWDATA;
  
  // Master Outputs
  logic [7:0] APB_PRDATA;

  // Instantiate the APB Top Module
  apb_top uut (
    .PCLK(PCLK),
    .RST_N(RST_N),
    .TX(TX),
    .APB_SWRITE(APB_SWRITE),
    .APB_SLV_PADDR(APB_SLV_PADDR),
    .APB_PWDATA(APB_PWDATA),
    .APB_PRDATA(APB_PRDATA)
  );

  // Clock Generation
  always #5 PCLK = ~PCLK;  // 10ns clock period

  // Test Sequence
  initial begin
    // Initialize signals
    PCLK = 0;
    RST_N = 0;
    TX = 0;
    APB_SWRITE = 0;
    APB_SLV_PADDR = 0;
    APB_PWDATA = 0;
    
    // Apply Reset
    #20 RST_N = 1;
    $display("Reset Applied");

    // Write to Slave 1 (Address Bit 8 = 0)
    APB_SLV_PADDR = 9'b000000001;  // Address 1
    APB_PWDATA = 8'hA5;            // Write Data
    APB_SWRITE = 1;                // Write Enable
    #10 APB_SWRITE = 0;            // End Write Transaction
    #20;
    $display("Write to Slave 1: Addr = %h, Data = %h", APB_SLV_PADDR, APB_PWDATA);
    
    // Write to Slave 2 (Address Bit 8 = 1)
    APB_SLV_PADDR = 9'b100000010;  // Address 2 (Slave 2)
    APB_PWDATA = 8'h5A;            // Write Data
    APB_SWRITE = 1;                // Write Enable
    #10 APB_SWRITE = 0;            // End Write Transaction
    #20;
    $display("Write to Slave 2: Addr = %h, Data = %h", APB_SLV_PADDR, APB_PWDATA);

    // Read from Slave 1
    APB_SLV_PADDR = 9'b000000001;  // Address 1
    APB_SWRITE = 0;                // Read Operation
    #20;
    $display("Read from Slave 1: Addr = %h, Data Read = %h", APB_SLV_PADDR, APB_PRDATA);

    // Read from Slave 2
    APB_SLV_PADDR = 9'b100000010;  // Address 2 (Slave 2)
    APB_SWRITE = 0;                // Read Operation
    #20;
    $display("Read from Slave 2: Addr = %h, Data Read = %h", APB_SLV_PADDR, APB_PRDATA);

    // Finish Simulation
    $display("APB Test Completed!");
    $finish;
  end

  // Dump waveform for debugging
  initial begin
    $dumpfile("apb_wave.vcd");
    $dumpvars();
  end
endmodule
