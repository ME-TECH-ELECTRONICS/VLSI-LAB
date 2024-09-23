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
            if(count == 2'b11)
                out <= ~out
        end
    end
endmodule