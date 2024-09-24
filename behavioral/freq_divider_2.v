module freq_divider_2(
    input clk,
    input rst,
    output reg out
);
    reg[2:0] count = 0;
    always @(posedge clk) begin
        if(rst) begin
            count <= 0;
            out <= 0;
        end
        else begin
            count <= count + 1;
            if(count == 2'b01)
                out <= ~out;
                count <= 0;
        end
    end
endmodule

module freq_divider_2_tb ();
    reg clk=0,rst=0;
    wire out;
    freq_divider_2 dut(clk,rst,out);
    always #5  clk = ~clk;
    initial begin
        rst =1; #10;
        rst = 0;
    end
endmodule