module sync_tb ();
  reg
      clk = 0,
      rst,
      detect_addr,
      full_0,
      full_1,
      full_2,
      empty_0,
      empty_1,
      empty_2,
      wr_en_reg,
      rd_en_0,
      rd_en_1,
      rd_en_2;
  reg [1:0] din;

  wire fifo_full, vld_out_0, vld_out_1, vld_out_2, soft_reset_0, soft_reset_1, soft_reset_2;
  wire [2:0] wr_en;

  synchronizer dut (
      clk,
      rst,
      din,
      detect_addr,
      full_0,
      full_1,
      full_2,
      empty_0,
      empty_1,
      empty_2,
      wr_en_reg,
      rd_en_0,
      rd_en_1,
      rd_en_2,
      wr_en,
      fifo_full,
      vld_out_0,
      vld_out_1,
      vld_out_2,
      soft_reset_0,
      soft_reset_1,
      soft_reset_2
  );

  always #5 clk = ~clk;

  initial begin
    rst = 0;
    detect_addr = 0;
    full_0 = 0;
    full_1 = 0;
    full_2 = 0;
    empty_0 = 0;
    empty_1 = 0;
    empty_2 = 0;
    wr_en_reg = 0;
    rd_en_0 = 0;
    rd_en_1 = 0;
    rd_en_2 = 0;
    din = 0;
    #10;
    rst = 1;
    #10;

    rd_en_0 = 1;
    rd_en_1 = 1;
    rd_en_2 = 0;
    din = 2'b00;
    detect_addr = 1;
    full_0 = 0;
    full_1 = 0;
    full_2 = 0;
    wr_en_reg = 1;
    empty_0 = 0;
    empty_1 = 0;
    empty_2 = 0;
  end


endmodule
