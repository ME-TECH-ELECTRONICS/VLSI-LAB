module seq_detector_moore (
    input rst,
    input din,
    output reg dout
);
    parameter IDLE = 2'b00,
              S0 = 2'b01,
              S1 = 2'b10,
              S2 = 2'b11;
    reg[1:0] NS, PS;

    always @(posedge clk) begin
        if(!rst)
            PS = IDLE;
        else
            PS = NS;
    end
endmodule