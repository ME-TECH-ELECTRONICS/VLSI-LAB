//Write a sv program which contains a 32 bit rand variable which should have 16 bit postionsof 1 in non consecutive

class task4;
    rand bit [31:0] val;

    constraint c_val {
        $countones(val) == 16; 
        foreach (val[i]) {
            if (i < 31) val[i] + val[i+1] <= 1;
        }
    }
endclass

module task4_tb;
    task4 r;
    initial begin
        r = new();
        repeat (5) begin
            r.randomize();
            $display("val = %b \t0x%0h", r.val,r.val);
        end
    end
endmodule

// # KERNEL: val = 10101010101010101010100101010101 	0xaaaaa955
// # KERNEL: val = 10101010100101010101010101010101 	0xaa955555
// # KERNEL: val = 10101010101010100101010101010101 	0xaaaa5555
// # KERNEL: val = 10101010101010010101010101010101 	0xaaa95555
// # KERNEL: val = 10101010101010100101010101010101 	0xaaaa5555