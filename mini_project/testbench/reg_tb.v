module reg_tb ();
  reg
      clk = 0,
      rst,
      pkt_valid = 0,
      fifo_full = 0,
      detect_addr = 0,
      ld_state = 0,
      laf_state = 0,
      full_state = 0,
      lfd_state = 0,
      rst_int_reg = 0;
  reg  [7:0] din;
  wire [7:0] dout;
  wire err, parity_done, low_pkt_valid;
  register uut (
      clk,
      rst,
      pkt_valid,
      din,
      fifo_full,
      detect_addr,
      ld_state,
      laf_state,
      full_state,
      lfd_state,
      rst_int_reg,
      dout,
      err,
      parity_done,
      low_pkt_valid
  );
  always #5 clk = ~clk;
  reg [7:0] payload_data, parity1 = 0, header1;
  integer i;
  initial begin
    rst = 0;
    #10;
    rst = 1;
    #10;
    pkt_valid = 1;
    detect_addr = 1;
    header1 = 8'b00010101;
    parity1 = parity1 ^ header1;
    din = header1;
    #10;
    detect_addr = 0;
    lfd_state   = 1;
    full_state  = 0;
    fifo_full   = 0;
    laf_state   = 0;
    for (i = 0; i < 8; i = i + 1) begin
      #10;
      lfd_state = 0;
      ld_state = 1;
      payload_data = {$random} % 256;
      din = payload_data;
      parity1 = parity1 ^ din;
    end
    #10;
    pkt_valid = 0;
    din = parity1;
    #10;
    ld_state = 0;
    #20;

    rst = 0;
    #10;
    rst = 1;
    #10;
    pkt_valid = 1;
    detect_addr = 1;
    header1 = 8'b00010101;
    parity1 = parity1 ^ header1;
    din = header1;
    #10;
    detect_addr = 0;
    lfd_state   = 1;
    full_state  = 0;
    fifo_full   = 0;
    laf_state   = 0;
    for (i = 0; i < 8; i = i + 1) begin
      #10;
      lfd_state = 0;
      ld_state = 1;
      payload_data = {$random} % 256;
      din = payload_data;
      parity1 = parity1 ^ din;
    end
    #10;
    pkt_valid = 0;
    din = 8'd46;
    #10;
    ld_state = 0;
    #20;

  end
endmodule
