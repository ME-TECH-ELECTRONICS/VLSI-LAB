module dataTypes_tb ();
    logic[7:0] a,b;
    logic [7:0] c,d;
    string e,g;
    bit[31:0] f = 128;

    typedef struct packed {
        int RED;
        int GREEN;
        int BLUE;
    } RGB_color;
    
    typedef struct{
        int RED;
        int GREEN;
        int BLUE;
        string ALPHA;
    } RGBA_color;

    typedef union packed {
        int i; 
        int s;
    } something;

    class Printer;
        function void log(string msg);
            $display(msg);
        endfunction 
        function void error(string msg);
            $display(msg);
        endfunction 
    endclass 

    RGB_color rgb; //struct
    RGBA_color rgba; //unpacked struct
    something some; //union
    Printer console; //class

    initial begin
        a=5; b=10;
        c = a + b;
        d = c - a;
        g = "Hello";
        rgb.RED = 122;
        rgb.GREEN = 233;
        rgb.BLUE = 111;

        rgba.RED = 122;
        rgba.GREEN = 233;
        rgba.BLUE = 111;
        rgba.ALPHA = "120";
        some.i = 0;
        
        e = $sformatf("%0d", f); //converts bit value to string
        $display("a=%0d b=%0d c=%0d d=%d e=%0s f=0x%0h",a,b,c,d,e,f);
        $display("Len: %0d",e.len());
        $display("RGB: #%0h%0h%0h", rgb.RED, rgb.GREEN, rgb.BLUE);
      $display("RGBA: #%0h%0h%0h%0s", rgba.RED, rgba.GREEN, rgba.BLUE, rgba.ALPHA); //unpacked struct
        $display("union: {i: %0d, s: %0d}", some.i,some.s);
        some.s = 255;
        $display("union: {i: %0d, s: %0d}", some.i,some.s);
        console.log("Hello World!");
        console.error("Error");

    end
endmodule