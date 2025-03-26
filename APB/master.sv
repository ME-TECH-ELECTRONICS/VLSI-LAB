`timescale 1ns / 1ns

module master_bridge (
    input [8:0] apb_write_paddr, // Write address for APB bus
    apb_read_paddr,             // Read address for APB bus
    input [7:0] apb_write_data, // Data to be written to APB bus
    PRDATA,                     // Data read from APB bus
    input PRESETn,              // Active-low reset signal
    PCLK,                       // Clock signal
    READ_WRITE,                 // Read (1) or Write (0) control signal
    transfer,                   // Transfer enable signal
    PREADY,                     // Peripheral ready signal
    output PSEL1, PSEL2,        // Peripheral select signals
    output reg PENABLE,         // Enable signal for APB transaction
    output reg [8:0] PADDR,     // APB address bus
    output reg PWRITE,          // Write enable signal
    output reg [7:0] PWDATA,    // Data to be written
    apb_read_data_out,          // Output for read data
    output PSLVERR              // Slave error flag
);

  // State registers
  reg [2:0] state, next_state;
  reg invalid_setup_error, setup_error, invalid_read_paddr, invalid_write_paddr, invalid_write_data;
  
  // FSM State Encoding
  parameter IDLE = 3'b001, SETUP = 3'b010, ENABLE = 3'b100;

  // Sequential logic: State transition
  always @(posedge PCLK) begin
    if (!PRESETn) state <= IDLE; // Reset to IDLE state
    else state <= next_state;
  end

  // Combinational logic: Next state logic and output control
  always @(state, transfer, PREADY) begin
    if (!PRESETn) next_state = IDLE;
    else begin
      PWRITE = ~READ_WRITE; // Determine read/write operation
      case (state)

        IDLE: begin
          PENABLE = 0;
          if (!transfer) next_state = IDLE;
          else next_state = SETUP;
        end

        SETUP: begin
          PENABLE = 0;
          if (READ_WRITE) PADDR = apb_read_paddr; // Load read address
          else begin
            PADDR  = apb_write_paddr; // Load write address
            PWDATA = apb_write_data;  // Load write data
          end
          
          if (transfer && !PSLVERR) next_state = ENABLE;
          else next_state = IDLE;
        end

        ENABLE: begin
          if (PSEL1 || PSEL2) PENABLE = 1; // Enable APB transaction
          
          if (transfer & !PSLVERR) begin
            if (PREADY) begin
              if (!READ_WRITE) next_state = SETUP; // Continue writing
              else begin
                next_state = SETUP;
                apb_read_data_out = PRDATA; // Store read data
              end
            end else next_state = ENABLE; // Wait for PREADY
          end else next_state = IDLE;
        end

        default: next_state = IDLE;
      endcase
    end
  end

  // Assign peripheral select signals based on address
  assign {PSEL1, PSEL2} = ((state != IDLE) ? (PADDR[8] ? {1'b0, 1'b1} : {1'b1, 1'b0}) : 2'd0);

  // Error detection logic
  always @(*) begin
    if (!PRESETn) begin
      setup_error = 0;
      invalid_read_paddr = 0;
      invalid_write_paddr = 0;
      invalid_write_data = 0;
    end else begin
      if (state == IDLE && next_state == ENABLE) setup_error = 1;
      else setup_error = 0;
      
      if ((apb_write_data === 8'dx) && (!READ_WRITE) && (state == SETUP || state == ENABLE))
        invalid_write_data = 1;
      else invalid_write_data = 0;
      
      if ((apb_read_paddr === 9'dx) && READ_WRITE && (state == SETUP || state == ENABLE))
        invalid_read_paddr = 1;
      else invalid_read_paddr = 0;
      
      if ((apb_write_paddr === 9'dx) && (!READ_WRITE) && (state == SETUP || state == ENABLE))
        invalid_write_paddr = 1;
      else invalid_write_paddr = 0;
      
      if (state == SETUP) begin
        if (PWRITE) begin
          if (PADDR == apb_write_paddr && PWDATA == apb_write_data) setup_error = 1'b0;
          else setup_error = 1'b1;
        end else begin
          if (PADDR == apb_read_paddr) setup_error = 1'b0;
          else setup_error = 1'b1;
        end
      end else setup_error = 1'b0;
    end
    
    // Generate overall error flag
    invalid_setup_error = setup_error || invalid_read_paddr || invalid_write_data || invalid_write_paddr;
  end

  assign PSLVERR = invalid_setup_error; // Assign error signal

endmodule