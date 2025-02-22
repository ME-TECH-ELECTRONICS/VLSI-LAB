module mux_2x1 (
    input logic a,
    input logic b,
    input logic s,
    output logic y
);
    assign  y = (s ? b : a);
endmodule

module mux_2x1_tb ();
    logic a,b,s,y;
    mux_2x1 dut(a,b,s,y);
    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, mux_2x1_tb);
        $monitor("a=%0d b=%0d s=%0d y=%0d",a,b,s,y);
        a=0; b=0; s=0; #10;
        a=0; b=1; s=0; #10;
        a=1; b=0; s=0; #10;
        a=1; b=1; s=0; #10;
        a=0; b=0; s=1; #10;
        a=0; b=1; s=1; #10;
        a=1; b=0; s=1; #10;
        a=1; b=1; s=1; #10;
    end
endmodule