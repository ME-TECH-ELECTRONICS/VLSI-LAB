module APB_SLAVE (
    input    logic CLK,
    input    logic RST_N,
    input    logic PWRITE,
    input    logic PSEL,
    input    logic PEN,
    input    logic [7:0] PADDR,
    input    logic [7:0] PWDATA,
    output   logic PREADY,
    output   logic PSLVERR,
    output   logic [7:0] PRDATA
);

  logic [7:0] MEMORY[0:7];

  always @(posedge CLK) begin
    if (!RST_N) begin
        PREADY  <= 0;
        PRDATA  <= 0;
        PSLVERR <= 0;
    end
    else begin
        if (PSEL) begin
            if (!PEN) begin
                PREADY <= 0;  // Setup phase, PREADY should be 0
            end else begin
                PREADY <= 1;  // Access phase, PREADY should be 1
                if (PWRITE) begin
                    MEMORY[PADDR] <= PWDATA;  // Write Operation
                end else begin
                    PRDATA <= MEMORY[PADDR];  // Read Operation
                end
            end
        end else begin
            PREADY <= 0;
        end
    end
  end
endmodule
