`timescale 1ns / 1ps
`include "SPI_CONTROLLER.sv"
`include "SPI_PERIFERIAL.sv"
module spi_tb;
  // Testbench Signals
  reg clk = 0;
  reg rst_n;
  reg start;
  reg [7:0] master_data_in;
  wire [7:0] master_data_out;
  wire SCK, MOSI, MISO, CS;
  reg  [7:0] slave_data_in;
  wire [7:0] slave_data_out;

  // Instantiate SPI Master
  SPI_CONTROLLER uut_master (
      clk,
      rst_n,
      start,
      master_data_in,
      MISO,
      master_data_out,
      MOSI,
      SCK,
      CS
  );

  // Instantiate SPI Slave
  SPI_PERIFERIAL uut_slave (
    SCK,
    CS,
    MOSI,
    MISO,
    slave_data_in,
    slave_data_out
  );

  // Generate Clock
  always #5 clk = ~clk;  // 100MHz clock

  // Test Procedure
  initial begin
    // Initialize signals
    rst_n = 0;
    start = 0;
    master_data_in = 8'hA5;  // Example data
    slave_data_in = 8'h3C;  // Response data from slave
    #20;

    // Release reset
    rst_n = 1;
    #10;

    // Start SPI transaction
    start = 1;
    #10;
    start = 0;

    // Wait for transfer to complete
    #200;

    // Display results
    $display("Master Sent: %h, Slave Received: %h", master_data_in, slave_data_out);
    $display("Slave Sent: %h, Master Received: %h", slave_data_in, master_data_out);

    // End simulation
    #50;
    $finish;
  end

  // Monitor signals
  initial begin
    $dumpfile("spi_tb.vcd");
    $dumpvars(0);
  end

endmodule
