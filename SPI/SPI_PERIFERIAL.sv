module SPI_PERIFERIAL (
    input  logic SCK,         // SPI clock from master
    input  logic CS,           // Slave Select
    input  logic MOSI,         // Master Out, Slave In
    output logic MISO,         // Master In, Slave Out
    input  logic [7:0] data_in,// Data to send
    output logic [7:0] data_out // Received data
);

  reg [2:0] bit_cnt;  // Bit counter
  reg [7:0] shift_reg;  // Shift register for received data

  always @(posedge SCK or posedge CS) begin
    if (CS) begin
      bit_cnt   <= 0;
      shift_reg <= data_in;  // Load new data when CS is high
    end else begin
      shift_reg <= {shift_reg[6:0], 1'b0};  // Shift data out
      MISO      <= shift_reg[7];  // Send MSB first

      data_out  <= {data_out[6:0], MOSI};  // Shift in received data
      bit_cnt   <= bit_cnt + 1;
    end
  end

endmodule
