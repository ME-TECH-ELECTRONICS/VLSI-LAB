module siso_shifter (
    input i, 
    input clk,
    input rst,
    output o,
);
    
    always @(posedge clk) begin
        if(rst) 
            o <= 0;
        else 
            
    end
endmodule

modul