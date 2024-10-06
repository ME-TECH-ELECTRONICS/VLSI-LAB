module FIFO_TB ();
  reg clk = 0, rst;
  reg wr_en, rd_en, soft_rst, lfd_state;

  reg  [7:0] din;
  wire [7:0] dout;
  wire full, empty;

  FIFO dut (
      clk,
      rst,
      soft_rst,
      wr_en,
      rd_en,
      lfd_state,
      din,
      full,
      empty,
      dout
  );
  always #5 clk = ~clk;
  integer i, j;
  initial begin
    rst = 0;
    #10;
    rst = 1;
    soft_rst = 1;
    wr_en = 0;
    rd_en = 0;
    din = 8'b0;
    #10;
    wr_en = 1;
    soft_rst = 0;
    lfd_state = 1;
    for (i = 0; i < 15; i = i + 1) begin
      din = $urandom_range(0, 255);
      #10;
      lfd_state = 0;
    end
    wr_en = 0;
    rd_en = 1;
    for (j = 0; j < 16; j = j + 1) begin
      $display("D[%d]: %h", j, dout);
      #10;
    end
  end
endmodule
