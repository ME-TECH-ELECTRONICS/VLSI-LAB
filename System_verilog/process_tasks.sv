module process_task();
    int a,b,c,sum;
    task t1(int x, int y);
        begin
            #10;
            $display("Sum: %0d", a+b);
        end
    endtask
    task t2(int x, int y);
        begin
            #10;
            $display("Sum: %0d", a+b);
        end
    endtask
    function int f1(int x, int y, int z);
        begin
            f1 = x + (z - y);
        end
    endfunction
    
    initial begin
        a = 37; b = 8; c = 66; #10;
        $display("/***** Initial Values ****/");
        $display("a = %0d b = %0d c = %0d");
    end
endmodule