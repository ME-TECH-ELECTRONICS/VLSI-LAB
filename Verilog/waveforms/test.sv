
module testbench();
    reg a,b,clk;
    initial begin
        $monitor("a = %0b b = %0b clk = %0b", a,b,clk);
        $dumpfile("out.vcd");
        $dumpvars();
        #200 $finish;
    end
    initial begin
        a = 0;
        b = 1;
        clk = 1;
        forever begin
            clk = ~clk;
            #10;
        end
    end
    initial begin
        #10 a = 1;
        b = 0;
        @(posedge clk)
        #2 a = #5 b;
        b = #3 b;
    end
    initial begin
        #70;
        @(posedge clk)
        @(posedge clk)
        @(posedge clk)
        a = 1'hx;
        @(negedge clk)
        b = 1'hx;
    end
    initial begin
        @(posedge clk)
        @(posedge clk)
        @(posedge clk)
        a = 1;
        @(negedge clk)
        b = 0;
    end

endmodule