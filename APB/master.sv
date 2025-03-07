module APB_MASTER(
    input    logic CLK,
    input    logic RST_N,
    input    logic PRDATA,
    input    logic PREADY,
    input    logic PSLVERR,
    input    logic [7:0] PRDATA,
    input    logic [8:0] APB_SLV_PADDR, //external in
    input    logic [7:0] APB_PWDATA, //external in
    input    logic TX, //external in
    input    logic APB_SWRITE, //external in

    output   logic PSEL1,
    output   logic PSEL2,
    output   logic PEN,
    output   logic PWRITE,
    output   logic [8:0] PADDR,
    output   logic [7:0] PWDATA,
    output   logic [7:0] APB_PRDATA //external out
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
                if(TX) NS = SETUP;
                else begin 
                    NS = IDLE;
                end
            end
            SETUP: begin
                PADDR = APB_SLV_PADDR;
                PWRITE = APB_SWRITE;

                if (TX) NS = ACCESS;
                else NS = IDLE;
            end
            ACCESS: begin
                PEN = 1;
                if(TX) begin 
                    if (PREADY) begin
                        if (PWRITE) begin
                            NS = SETUP;
                        end
                        else begin
                            NS = SETUP;
                            APB_PRDATA = PRDATA;
                        end 
                    end
                    else  NS = ACCESS;
                end
                else NS = IDLE;
            end
            default: NS = IDLE;
        endcase
    end

    assign {PSEL1, PSEL2} = ((PS != IDLE) ? (PADDR[8] ? 2'b01 : 2'b10) : 2'd0);
endmodule