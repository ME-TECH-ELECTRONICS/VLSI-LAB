//write a constraint to generate a random even and od number between 20 and 100

class task2;
    rand bit[6:0] odd;
    rand bit[6:0] even;

    constraint con1 {
        odd >= 20 && odd <= 100 && odd % 2 == 1;
        even >= 20 && even <= 100 && even % 2 == 0;
    }
endclass

module task1_tb;
        task2 t2;
    initial begin
        t2 = new();

        repeat(10) begin
            t2.randomize();
            $display("ODD: %0d", t2.odd);
            $display("EVEN: %0d", t2.even);
            $display("=======================");
        end
    end
endmodule

// # KERNEL: ODD: 35
// # KERNEL: EVEN: 46
// # KERNEL: =======================
// # KERNEL: ODD: 75
// # KERNEL: EVEN: 88
// # KERNEL: =======================
// # KERNEL: ODD: 93
// # KERNEL: EVEN: 36
// # KERNEL: =======================
// # KERNEL: ODD: 43
// # KERNEL: EVEN: 100
// # KERNEL: =======================
// # KERNEL: ODD: 89
// # KERNEL: EVEN: 82
// # KERNEL: =======================
