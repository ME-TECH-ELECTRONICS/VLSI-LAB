// 1.Write a code to genrate random number between 135 and 257
 
class task1;
    rand bit[8:0] num;                                                                                                                        0                                                                                                                                                           
    constraint con1 { num inside {[135 : 257]}; }
endclass

module task1_tb;
        task1 t1;
    initial begin
        t1 = new();

        repeat(10) begin
            t1.randomize();
            $display("Number: %0d", t1.num);
        end
    end
endmodule

// # KERNEL: Number: 212
// # KERNEL: Number: 156
// # KERNEL: Number: 232
// # KERNEL: Number: 170
// # KERNEL: Number: 250