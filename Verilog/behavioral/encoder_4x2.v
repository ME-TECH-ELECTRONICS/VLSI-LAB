module encoder_4x2 (
    input[3:0] i,
    output reg[1:0] o
);
    always @(*) begin
        o[0] = i[3] | i[2];
        o[1] = i[2] | i[1];
    end
endmodule

module encoder_4x2_tb ();
    reg[3:0] i;
    wire [1:0] o;
    encoder_4x2 encoder_4x2_i (i, o);
   
    initial begin
        i=4'b0000; #10;
        i=4'b0001; #10;
        i=4'b0010; #10;
        i=4'b0100; #10;
        i=4'b1000; #10;
    end
endmodule