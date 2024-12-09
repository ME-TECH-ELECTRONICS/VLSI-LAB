//write a constraint such that sum of any 3 conceutive elements should be an even number

class task9;
  randc bit[4:0] num[5];
    constraint con1 {
       foreach (num[i]) {
        (num[i] + num[i + 1] + num[i + 2]) % 2 == 0;
       }
    }
endclass

module task9_tb;
    int result;
    task9 r;

    initial begin
        r = new();
        repeat(5) begin 
            r.randomize();
            $display("%p", r.num);
        end
    end
endmodule

// # KERNEL: '{18, 18, 14, 12, 26}
// # KERNEL: '{2, 26, 30, 16, 14}
// # KERNEL: '{28, 10, 6, 8, 30}
// # KERNEL: '{30, 4, 18, 26, 6}
// # KERNEL: '{10, 2, 22, 28, 28}