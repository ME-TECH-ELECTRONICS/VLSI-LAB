module reg_tb();
  // Registers for inputs and control signals
  reg clk = 0, rst, pkt_valid = 0, fifo_full = 0;
  reg detect_addr = 0, ld_state = 0, laf_state = 0;
  reg full_state = 0, lfd_state = 0, rst_int_reg = 0;
  reg [7:0] din;                // 8-bit data input

  // Wires for outputs from the register module
  wire [7:0] dout;              // 8-bit data output
  wire err, parity_done, low_pkt_valid; // Status signals

  // Instantiate the register module as the Unit Under Test (UUT)
  register uut (
      clk, rst, pkt_valid, din, fifo_full, 
      detect_addr, ld_state, laf_state, 
      full_state, lfd_state, rst_int_reg, 
      dout, err, parity_done, low_pkt_valid
  );

  // Clock generation: Toggle clock every 5 time units
  always #5 clk = ~clk;

  // Variables for generating and tracking data and parity
  reg [7:0] payload_data, parity1 = 0, header1;
  integer i;  // Loop variable

  // Initial block: Setup and provide stimulus
  initial begin
    // Reset the system initially
    rst = 0;            // Assert reset
    #10;
    rst = 1;            // De-assert reset to start the system
    #10;

    // First packet transmission
    pkt_valid = 1;       // Indicate a valid packet
    detect_addr = 1;     // Enable address detection
    header1 = 8'b00010101; // Example header data
    parity1 = parity1 ^ header1; // Update parity with header
    din = header1;       // Provide header as input
    #10;

    // Address detection complete, start sending payload data
    detect_addr = 0;     
    lfd_state = 1;       
    full_state = 0;      
    fifo_full = 0;       
    laf_state = 0;       

    // Loop to send 8 payload bytes
    for (i = 0; i < 8; i = i + 1) begin
      #10;
      lfd_state = 0;     // Disable LFD state after first cycle
      ld_state = 1;      // Enable loading state
      payload_data = {$random} % 256; // Generate random payload data
      din = payload_data; // Provide payload as input
      parity1 = parity1 ^ din; // Update parity
    end

    // Send parity byte after payload data
    #10;
    pkt_valid = 0;       // Mark end of packet
    din = parity1;       // Provide calculated parity as input
    #10;
    ld_state = 0;        // Disable loading state
    #20;                 // Wait for 20 time units

    // Reset system for second test case
    rst = 0;
    #10;
    rst = 1;
    #10;

    // Second packet transmission with intentional parity error
    pkt_valid = 1;
    detect_addr = 1;
    header1 = 8'b00010101;
    parity1 = parity1 ^ header1;
    din = header1;
    #10;

    detect_addr = 0;
    lfd_state = 1;
    full_state = 0;
    fifo_full = 0;
    laf_state = 0;

    // Send 8 payload bytes
    for (i = 0; i < 8; i = i + 1) begin
      #10;
      lfd_state = 0;
      ld_state = 1;
      payload_data = {$random} % 256;
      din = payload_data;
      parity1 = parity1 ^ din;
    end

    // Introduce a parity error (send incorrect parity byte)
    #10;
    pkt_valid = 0;
    din = 8'd46; // Incorrect parity byte
    #10;
    ld_state = 0;
    #20;
  end
endmodule
