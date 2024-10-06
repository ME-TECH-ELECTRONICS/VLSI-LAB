module fsm_tb ();
  reg
      clk = 0,
      rst,
      pkt_valid,
      fifo_full,
      fifo_empty_0,
      fifo_empty_1,
      fifo_empty_2,
      soft_rst_0,
      soft_rst_1,
      soft_rst_2,
      parity_done,
      low_pkt_valid;
  reg [1:0] din;
  wire wr_en_req, detect_addr, lfd_state, laf_state, full_state, rst_int_req, busy;

  fsm_controller uut (
      clk,
      rst,
      pkt_valid,
      fifo_full,
      fifo_empty_0,
      fifo_empty_1,
      fifo_empty_2,
      soft_rst_0,
      soft_rst_1,
      soft_rst_2,
      parity_done,
      low_pkt_valid,
      din,
      wr_en_req,
      detect_addr,
      lfd_state,
      laf_state,
      full_state,
      rst_int_req,
      busy
  );
  always #5 clk = ~clk;

  initial begin
    rst = 0;
    pkt_valid = 0;
    fifo_full = 0;
    fifo_empty_0 = 0;
    fifo_empty_1 = 0;
    fifo_empty_2 = 0;
    soft_rst_0 = 0;
    soft_rst_1 = 0;
    soft_rst_2 = 0;
    parity_done = 0;
    low_pkt_valid = 0;
    din = 0;
    #10 rst = 1;

    pkt_valid = 1;
    fifo_empty_0 = 1;
    din = 0;
    #10;
    fifo_full = 0;
    pkt_valid = 0;
    #10;
    fifo_full = 0;
  end

endmodule
