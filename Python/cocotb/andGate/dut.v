module dut (
    input a,
    input b,
    output y
);
    assign y = a & b;

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(1, dut);
    end
    
endmodule