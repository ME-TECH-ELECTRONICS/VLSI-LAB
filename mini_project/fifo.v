module fifo (
    input clk,
    input rst,
    input soft_rst,
    input wr_en,
    input rd_en,
    input lfd_state,
    input [7:0] din,
    output full,
    output empty,
    output reg [7:0] dout
);
  reg [8:0] mem[15:0];  // 9-bit wide memory, 16 deep
  reg [4:0] wr_ptr, rd_ptr;  // 4-bit pointers and counter
  reg [6:0] intCount;
  integer i;
  reg lfd_state_t;  // Temporary lfd_state register

  always @(posedge clk) begin
    if (!rst) lfd_state_t <= 0;
    else lfd_state_t <= lfd_state;
  end

  // Reset and counting algorithm
  always @(posedge clk) begin
    if (!rst) begin
      dout   <= 0;
      wr_ptr <= 0;
      rd_ptr <= 0;
      for (i = 0; i < 16; i = i + 1) begin
        mem[i] <= 0;
      end
    end else if (soft_rst || (intCount == 0)) dout <= 8'bz;
  end

  assign full = (wr_ptr == ({~rd_ptr[4], rd_ptr[3:0]}));  // Full when all 16 positions are occupied
  assign empty = (rd_ptr == wr_ptr);  // Empty when count is zero

  // Write operation
  always @(posedge clk) begin
    if (rst) begin
      if (wr_en && !full) begin
        if (lfd_state_t) begin
          mem[wr_ptr[3:0]][8]   <= 1'b1;
          mem[wr_ptr[3:0]][7:0] <= din;
        end else begin
          mem[wr_ptr[3:0]][8]   <= 1'b0;
          mem[wr_ptr[3:0]][7:0] <= din;
        end
      end
    end
  end

  // Read operation
  always @(posedge clk) begin
    if (rst && rd_en && !empty) begin
      if (mem[rd_ptr[3:0]][8] == 1'b1) begin
        intCount = mem[rd_ptr[3:0]][7:2] + 1'b1;
      end else if (intCount != 0) begin
        intCount = intCount - 1'b1;
      end
      dout <= mem[rd_ptr[3:0]][7:0];  // Read only the data part
    end
  end

  // Pointers algorithm
  always @(posedge clk) begin
    if (!rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
    end else if (wr_en && !full) wr_ptr <= wr_ptr + 1;
    else if (rd_en && !empty) rd_ptr <= rd_ptr + 1;

  end

endmodule
