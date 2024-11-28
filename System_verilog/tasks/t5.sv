//  write a constrant to genrate factrial of first 10 numbers

class task5;
    randc int fact;

    constraint con1 {
       fact >= 0 && fact < 10;
    }

    function int factorial(int num);
        if (num == 0)
            return 1;
        else
            return num * factorial(num - 1);
    endfunction
endclass

module task4_tb;
    int result;
    task5 r;

    initial begin
        r = new();
        repeat(10) begin 
            r.randomize();
            result = r.factorial(r.fact);
            $display("factorial of %0d is %0d", r.fact, result);
        end
    end
endmodule

// # KERNEL: factorial of 7 is 5040
// # KERNEL: factorial of 0 is 1
// # KERNEL: factorial of 5 is 120
// # KERNEL: factorial of 6 is 720
// # KERNEL: factorial of 3 is 6
// # KERNEL: factorial of 2 is 2
// # KERNEL: factorial of 9 is 362880
// # KERNEL: factorial of 1 is 1
// # KERNEL: factorial of 4 is 24
// # KERNEL: factorial of 8 is 40320