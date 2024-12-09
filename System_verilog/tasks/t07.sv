//  write a constrant to genrate factrial of first 5 odd numbers

class task7;
    randc int fact;

    constraint con1 {
       fact >= 0 && fact < 5 && fact % 2 == 1;
    }

    function int factorial(int num);
        if (num == 0)
            return 1;
        else
            return num * factorial(num - 1);
    endfunction
endclass

module task7_tb;
    int result;
    task7 r;

    initial begin
        r = new();
        repeat(5) begin 
            r.randomize();
            result = r.factorial(r.fact);
            $display("factorial of %0d is %0d", r.fact, result);
        end
    end
endmodule

// # KERNEL: factorial of 3 is 6
// # KERNEL: factorial of 1 is 1
// # KERNEL: factorial of 1 is 1
// # KERNEL: factorial of 3 is 6
// # KERNEL: factorial of 1 is 1