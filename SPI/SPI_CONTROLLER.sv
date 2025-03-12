module SPI_CONTROLLER (
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic [7:0] in_data,
    input  logic MISO,
    output logic [7:0] out_data,
    output logic MOSI,
    output logic SCK,
    output logic CS
);
  reg [2:0] bit_cnt;
  reg [7:0] shift_reg; 
  reg [7:0] recv_reg; 
  reg       busy;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_data <= 0;
      MOSI <= 0;
      SCK <= 0;
      CS <= 1;
      busy <= 0;
      bit_cnt <= 0;
      shift_reg <= 0;
      recv_reg <= 0;
    end else if (start && !busy) begin
        CS <= 0;
        busy <= 1;
        shift_reg <= in_data;
        bit_cnt <= 0;
    end else if (busy) begin
        SCK <= ~SCK;
        if(SCK) begin
            recv_reg <= {recv_reg[6:0], MISO};
            bit_cnt <= bit_cnt + 1;
    
            if (bit_cnt == 7) begin
                out_data <= recv_reg;
                busy <= 0;           
                CS <= 1;             
            end
        end else begin
            MOSI <= shift_reg[7];
            shift_reg <= {shift_reg[6:0], 1'b0};
        end
    end
  end

endmodule
