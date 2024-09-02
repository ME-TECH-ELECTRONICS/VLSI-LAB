`define M 4
module mux_Nx1 #( parameter N = 2**(`M)) (
    input [N-1:0] in,
    input [`M-1:0] sel,
    output reg y
);

    always @(*) begin
        y = in[sel];
    end
    
endmodule

module mux_Nx1_tb;
    parameter N = 2**(`M);
    reg [N-1:0] in;
    reg [`M-1:0] sel;
    wire y;

    mux_Nx1 dut(in,sel,y);
    initial begin
        in = 16'h0001; sel = 0; #10; //0000 0000 0000 0001
        in = 16'h0002; sel = 1; #10;
        in = 16'h0004; sel = 2; #10; //0000
 
        in = 16'h0080; sel = 7; #10;
        in = 16'h0100; sel = 8; #10;
        in = 16'h0200; sel = 9; #10;
        in = 16'h0400; sel = 9; #10;
    end
endmodule