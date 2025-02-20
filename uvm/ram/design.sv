module ram_16x8_SP (
    input clk,
    input rst,
    input rw_n,
    input [3:0] addr,
    input [7:0] din,
    output reg [7:0] dout
);

    reg [7:0] mem [15:0];
    integer i;
    always @(posedge clk) begin
        if(!rst) begin
            for (i = 0; i<16; i=i+1) begin
                mem[i] = 0;
            end
        end
        else begin
            if(!rw_n) begin
                mem[addr] = din;
            end
            else begin
                dout = mem[addr];
            end
        end
    end
endmodule
