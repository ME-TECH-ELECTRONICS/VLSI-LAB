module APB_MASTER(
    input    logic CLK,
    input    logic RST_N,
    input    logic PRDATA,
    input    logic PREADY,
    input    logic PSLVERR,
    input    logic [7:0] PRDATA,
    input    logic transfer,
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
    reg [7:0] MEMORY [7:0];

    always @(CLK) begin
        if (!RST_N) begin
            PS <= IDLE;
        end
        else begin
            PS <= NS;
        end
    end

    always @(*) begin
        case (PS)
            IDLE : begin
                if(PSEL && !PEN) NS = SETUP;
                else begin 
                    NS = IDLE;
                    PREADY = 0;
                end
            end
            SETUP: begin
                if (!PSEL || !PEN) begin
                    NS = IDLE;
                end
                else begin
                    NS = ACCESS;
                    if(PWRITE) begin
                        MEMORY[PADDR] <= PWDATA;
                        PREADY <= 1;
                        PSLVERR <= 0;
                    end
                    else begin
                        PREADY <= 1;
                        PSLVERR <= 0;
                        PRDATA <= MEMORY[PADDR];
                    end
                end
            end
        endcase
    end
endmodule