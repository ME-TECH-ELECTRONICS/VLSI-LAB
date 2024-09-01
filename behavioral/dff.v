module dff (
    input wire D,
    input wire clk
    input wire rst,
    output reg Q;
);
    always @(posedge clk) begin
        if(rst) 
            Q <= 0;
        else
            Q <= D;
    end
endmodule

module tb();
    clk = 0;
    always #5 clk=~clk;
    initial begin

    end
endmodule