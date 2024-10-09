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
  reg [3:0] wr_ptr, rd_ptr, count;  // 4-bit pointers and counter
  reg [6:0] intCount;
  integer i;
  reg tmp_lfd_state;

  // Reset and counting algorithm
  always @(posedge clk) begin
    if (!rst) begin
      dout   <= 0;
      wr_ptr <= 0;
      rd_ptr <= 0;
      count  <= 0;
      for (i = 0; i < 16; i = i + 1) begin
        mem[i] <= 0;
      end
    end
    else begin 
        if (soft_rst || (intCount==0)) dout <= 8'bz;
        case({wr_ptr,rd_ptr})
            2'b01: count = count - 1;
            2'b10: count = count + 1;
            2'b00, 2'b11: count = count;
    end
  end
  always @(lfd_state) begin
    tmp_lfd_state <= lfd_state
  end
  assign full  = (count == 16);  // Full when all 16 positions are occupied
  assign empty = (count == 0);  // Empty when count is zero

  // Write operation
  always @(posedge clk) begin
    if (rst) begin
      if (wr_en && !full) begin
        mem[wr_ptr] <= {lfd_state, din};  // Write lfd_state and data 110101010
        wr_ptr <= wr_ptr + 1;
    
      end
    end
  end

  // Read operation
  always @(posedge clk) begin
    if (rst) begin
      if (rd_en && !empty) begin
        if (mem[rd_ptr][8] == 1'b1) begin
          intCount = mem[rd_ptr][7:2] + 1'b1;
        end else if (intCount != 0) begin
          intCount = intCount - 1;
        end
        dout   <= mem[rd_ptr][7:0];  // Read only the data part
        rd_ptr <= rd_ptr + 1;
    
      end
    end
  end
endmodule