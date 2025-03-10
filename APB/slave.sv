module APB_SLAVE (
    input    logic CLK,
    input    logic RST_N,
    input    logic PWRITE,
    input    logic PSEL,
    input    logic PEN,
    input    logic [7:0] PADDR,
    input    logic [7:0] PWDATA
    output   logic PREADY,
    output   logic PSLVERR,
    output   logic [7:0] PRDATA
);

    logic [7:0] MEMORY [7:0];
    
    always @(*) begin
        if(!PRESETn)
            PREADY = 0;
        else
	    if(PSEL && !PEN && !PWRITE) begin 
            PREADY = 0; 
        end
	         
	    else if(PSEL && PEN && !PWRITE) begin  
            PREADY = 1;
            PRDATA = MEMORY[PADDR];
	    end
        else if(PSEL && !PENABLE && PWRITE) begin  
            PREADY = 0; 
        end
	    else if(PSEL && PENABLE && PWRITE) begin  
            PREADY = 1;
	        MEMORY[PADDR] = PWDATA; 
        end
        else 
            PREADY = 0;
    end
endmodule