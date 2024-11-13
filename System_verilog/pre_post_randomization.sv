class generator;
    rand bit [4:0] a, b; 
    bit [3:0] y; 

    // Constructor
    function new();
        y = 4'b1111;
    endfunction

    function void pre_randomize();
        y = 4'b1111;
    endfunction

    function void post_randomize();
        if (b >= 16) begin
            b = b % 16;
        end
    endfunction
endclass

module tb;
    generator g;
    int i = 0; 

    initial begin
        g = new();
        for (i = 0; i < 5; i = i + 1) begin
            if (g.randomize()) begin
                $display("Value of a: %0d, b: %0d, and y: %0d", g.a, g.b, g.y);
            end else begin
                $display("Randomization failed at iteration %0d", i);
            end
            #10;
        end
    end
endmodule
