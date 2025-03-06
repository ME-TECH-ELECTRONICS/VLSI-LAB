module APB_SLAVE (
    input    logic CLK,
    input    logic RST_N,
    input    logic PWRITE,
    input    logic PSEL,
    input    logic PEN,
    input    logic [31:0] PADDR,
    input    logic [31:0] PWDATA
    output   logic PREADY,
    output   logic PSLVERR,
    output   logic [31:0] PRDATA,

);
    
endmodule