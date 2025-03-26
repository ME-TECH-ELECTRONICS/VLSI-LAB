`timescale 1ns / 1ns
`include "apb_top.sv" // Include the APB Protocol module

module test;

  // Declare testbench signals
  reg PCLK, PRESETn, transfer, READ_WRITE;
  reg [8:0] apb_write_paddr;
  reg [7:0] apb_write_data;
  reg [8:0] apb_read_paddr;
  wire [7:0] apb_read_data_out;
  wire PSLVERR;
  reg [7:0] data, expected;

  // Instantiate the APB Protocol module
  APB_Protocol dut_c (
      PCLK,
      PRESETn,
      transfer,
      READ_WRITE,
      apb_write_paddr,
      apb_write_data,
      apb_read_paddr,
      PSLVERR,
      apb_read_data_out
  );

  integer i, j;

  // Generate clock signal with 10ns period
  initial begin
    PCLK <= 0;
    forever #5 PCLK = ~PCLK;
  end

  initial begin
    // Initialize signals
    PRESETn  <= 0;
    transfer <= 0;
    READ_WRITE = 0;
    apb_write_paddr = 0;
    apb_write_data = 0;
    apb_read_paddr = 0;

    // Apply reset
    @(posedge PCLK) PRESETn = 1;
    
    // No write address available but request for write operation
    @(posedge PCLK) transfer = 1;
    repeat (2) @(posedge PCLK);
    @(negedge PCLK) Write_slave1;  // Perform write operation to slave 1

    repeat (3) @(posedge PCLK);
    Write_slave2;  // Perform write operation to slave 2

    @(posedge PCLK);
    apb_write_paddr = 9'd526;
    apb_write_data  = 9'd9;
    repeat (2) @(posedge PCLK);
    apb_write_paddr = 9'd22;
    apb_write_data  = 9'd35;
    repeat (2) @(posedge PCLK);
    
    // Initiate read operations
    @(posedge PCLK) READ_WRITE = 1;
    PRESETn  <= 0;
    transfer <= 0;
    @(posedge PCLK) PRESETn = 1;
    
    repeat (3) @(posedge PCLK) transfer = 1;  // No read address available but request for read operation
    repeat (2) @(posedge PCLK) Read_slave1;  // Perform read operation from slave 1

    repeat (3) @(posedge PCLK);
    Read_slave2;  // Perform read operation from slave 2

    repeat (3) @(posedge PCLK);
    apb_read_paddr = 9'd45;  // Request read operation from an address not written to
    repeat (4) @(posedge PCLK);
    $finish;
  end

  // Task to write data to Slave 1
  task Write_slave1;
    begin
      transfer = 1;
      for (i = 0; i < 8; i = i + 1) begin
        repeat (2)
          @(negedge PCLK) begin
            data = i;
            apb_write_data = 2 * i;
            apb_write_paddr = {1'b0, data};
          end
      end
    end
  endtask

  // Task to write data to Slave 2
  task Write_slave2;
    begin
      for (i = 0; i < 8; i = i + 1) begin
        repeat (2)
          @(negedge PCLK) begin
            data = i;
            apb_write_paddr = {1'b1, data};
            apb_write_data = i;
          end
      end
    end
  endtask

  // Task to read data from Slave 1
  task Read_slave1;
    begin
      for (j = 0; j < 8; j = j + 1) begin
        repeat (2)
          @(negedge PCLK) begin
            data = j;
            apb_read_paddr = {1'b0, data};
          end
      end
    end
  endtask

  // Task to read data from Slave 2
  task Read_slave2;
    begin
      for (j = 0; j < 8; j = j + 1) begin
        repeat (2)
          @(negedge PCLK) begin
            data = j;
            apb_read_paddr = {1'b1, data};
          end
      end
    end
  endtask

  // Dump waveform for simulation
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

endmodule