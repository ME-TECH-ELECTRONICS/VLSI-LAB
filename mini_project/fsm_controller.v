module fsm_controller (
    input clk,
    input rst,
    input pkt_valid,
    input fifo_full,
    input fifo_empty_0,
    input fifo_empty_1,
    input fifo_empty_2,
    input soft_rst_0,
    input soft_rst_1,
    input soft_rst_2,
    input parity_done,
    input low_pkt_valid,
    input [1:0] din,
    output reg wr_en_req,
    output reg detect_addr,
    output reg ld_state,
    output reg laf_state,
    output reg lfd_state,
    output reg full_state,
    output reg rst_int_reg,
    output reg busy
);
  //fsm controller for 1x3 router 

  parameter DECODE_ADDRESS = 3'b000;
  parameter LOAD_FIRST_DATA = 3'b001;
  parameter LOAD_DATA = 3'b010;
  parameter WAIT_TILL_EMPTY = 3'b011;
  parameter CHECK_PARITY_ERROR = 3'b100;
  parameter LOAD_PARITY = 3'b101;
  parameter FIFO_FULL_STATE = 3'b110;
  parameter LOAD_AFTER_FULL = 3'b111;

  reg [2:0] PS, NS;

  always @(posedge clk) begin
    if (!rst) begin
      wr_en_req <= 0;
      detect_addr <= 0;
      ld_state <= 0;
      laf_state <= 0;
      lfd_state <= 0;
      full_state <= 0;
      rst_int_reg <= 0;
      busy <= 0;
      PS <= DECODE_ADDRESS;
    end
    else if (soft_rst_0 || soft_rst_1 || soft_rst_2) PS <= DECODE_ADDRESS;
    else PS <= NS;
  end

  always @(*) begin
    case (PS)
      DECODE_ADDRESS: begin
        // detect_addr <= 1;
        // busy <= 0;
        if ((pkt_valid && din == 0 && fifo_empty_0) || (pkt_valid && din == 1 && fifo_empty_1) || (pkt_valid && din == 2 && fifo_empty_2))
          NS <= LOAD_FIRST_DATA;
        else if ((pkt_valid && din == 0 && ~fifo_empty_0) || (pkt_valid && din == 1 && !fifo_empty_1) || (pkt_valid && din == 2 && !fifo_empty_2))
          NS = WAIT_TILL_EMPTY;
        else NS <= DECODE_ADDRESS;
      end

      LOAD_FIRST_DATA: begin
        // lfd_state <= 1;
        // busy <= 1;
        NS <= LOAD_DATA;
      end

      LOAD_DATA: begin
        // ld_state <= 1;
        // busy <= 0;
        // wr_en_req <= 1;
        if (fifo_full) begin
          NS <= FIFO_FULL_STATE;
        end else if (!fifo_full && !pkt_valid) NS <= LOAD_PARITY;
        else NS <= LOAD_DATA;
      end

      WAIT_TILL_EMPTY: begin
        // wr_en_req <= 0;
        // busy <= 1;
        if (fifo_empty_0 || fifo_empty_1 || fifo_empty_2) NS <= LOAD_FIRST_DATA;
        else NS <= WAIT_TILL_EMPTY;
      end

      FIFO_FULL_STATE: begin
        // busy <= 1;
        // wr_en_req <= 0;
        full_state <= 1;
        if (!fifo_full) NS <= LOAD_AFTER_FULL;
        else NS <= FIFO_FULL_STATE;
      end

      LOAD_AFTER_FULL: begin
        // wr_en_req <= 1;
        // busy <= 1;
        // laf_state <= 1;
        if (!parity_done && !low_pkt_valid) NS <= LOAD_DATA;
        else if (!parity_done && low_pkt_valid) NS <= LOAD_PARITY;
        else if (parity_done) NS <= DECODE_ADDRESS;
      end

      LOAD_PARITY: begin
        // busy <= 1;
        // wr_en_req <= 1;
        NS <= CHECK_PARITY_ERROR;
      end
      CHECK_PARITY_ERROR: begin
        // rst_int_reg <= 1;
        // busy <= 1;
        if (!fifo_full) NS = DECODE_ADDRESS;
        else NS = FIFO_FULL_STATE;
      end

      default: PS = DECODE_ADDRESS;
    endcase
  end

  always @(posedge clk) begin
    detect_addr <= (PS == DECODE_ADDRESS);
    lfd_state <= (PS == LOAD_FIRST_DATA);
    busy <= (((PS == LOAD_FIRST_DATA) || (PS == LOAD_PARITY) || (PS == FIFO_FULL_STATE) ||(PS == LOAD_AFTER_FULL) || (PS ==     WAIT_TILL_EMPTY) || (PS == CHECK_PARITY_ERROR)) ? 1 : 0) || (((PS == LOAD_DATA) || (PS == DECODE_ADDRESS)) ? 0 : 1);
    ld_state <= (PS == LOAD_DATA);
    wr_en_req <= (((PS == LOAD_DATA) || (PS == LOAD_PARITY) || (PS == LOAD_AFTER_FULL)) ? 1 : 0) || (((PS == FIFO_FULL_STATE) || (PS ==     WAIT_TILL_EMPTY) || (PS == DECODE_ADDRESS) || (PS == LOAD_FIRST_DATA) || (PS == CHECK_PARITY_ERROR)) ? 0 : 1);
    full_state <= (PS == FIFO_FULL_STATE);
    laf_state <= (PS == LOAD_AFTER_FULL);
    rst_int_reg <= (PS == CHECK_PARITY_ERROR);
  end
  // assign detect_addr = (PS == DECODE_ADDRESS);
  // assign lfd_state = (PS == LOAD_FIRST_DATA);
  // assign busy = (((PS == LOAD_FIRST_DATA) || (PS == LOAD_PARITY) || (PS == FIFO_FULL_STATE) ||(PS == LOAD_AFTER_FULL) || (PS == WAIT_TILL_EMPTY) || (PS == CHECK_PARITY_ERROR)) ? 1 : 0) || (((PS == LOAD_DATA) || (PS == DECODE_ADDRESS)) ? 0 : 1);
  // assign ld_state = (PS == LOAD_DATA);
  // assign wr_en_req = (((PS == LOAD_DATA) || (PS == LOAD_PARITY) || (PS == LOAD_AFTER_FULL)) ? 1 : 0) || (((PS == FIFO_FULL_STATE) || (PS == WAIT_TILL_EMPTY) || (PS == DECODE_ADDRESS) || (PS == LOAD_FIRST_DATA) || (PS == CHECK_PARITY_ERROR)) ? 0 : 1);
  // assign full_state = (PS == FIFO_FULL_STATE);
  // assign laf_state = (PS == LOAD_AFTER_FULL);
  // assign rst_int_reg = (PS == CHECK_PARITY_ERROR);
endmodule

