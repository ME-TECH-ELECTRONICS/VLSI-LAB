module dataTypes_tb ();
    logic[7:0] a,b;
    logic [7:0] c,d;
    string e,g;
    bit[31:0] f = 128;
    int char = "D";
    initial begin
        a=5; b=10;
        c = a + b;
        d = c - a;
        g = "Hello";
        e = $sformatf("%0d", f); //converts bit value to string
        $display("a=%0d b=%0d c=%0d d=%d e=%0s f=0x%0h",a,b,c,d,e,f);
        $display("Len: %0d",e.len());

    end
endmodule