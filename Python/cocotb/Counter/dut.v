module dut(clk, rst, count);
    input clk;
    input rst;
    output [3:0] count;
    
    reg [3:0] counter;
    
    always @(posedge clk) begin 
        if(rst)
            counter <= 0;
        else
            counter <= counter + 1;
    end
    
    assign count = counter;
    
    initial begin
        $dumpfile("out.vcd");
        $dumpvars(1, dut);
    end
endmodule