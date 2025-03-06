module APB_MASTER(
    input    logic CLK,
    input    logic RST_N,
    input    logic PRDATA,
    input    logic PREADY,
    input    logic PSLVERR,
    input    logic [7:0] PRDATA,
    output   logic PSEL1,
    output   logic PSEL2,
    output   logic PEN,
    output   logic PWRITE,
    output   logic [8:0] PADDR,
    output   logic [7:0] PWDATA
);
    parameter IDLE = 2'b00;
    parameter SETUP = 2'b01;
    parameter ACCESS = 2'b10;
    
    reg [1:0] PS, NS;
endmodule