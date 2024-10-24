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
            $display("Difference: %0d", a-b);
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
        $display("a = %0d b = %0d c = %0d", a,b,c);
        $display("/****FORK JOIN****/");
        fork
            t1(a,b);
            t2(a,b);
        join
        $display("Sum & Differnce: %0d", f1(a,b,c));
         $display("/****FORK JOIN ANY****/");
        fork
            t1(a,b);
            t2(a,b);
        join_any
        $display("Sum & Differnce: %0d", f1(a,b,c));
         $display("/****FORK JOIN NONE****/");
        fork
            t1(a,b);
            t2(a,b);
        join_none
        $display("Sum & Differnce: %0d", f1(a,b,c));
    end
endmodule