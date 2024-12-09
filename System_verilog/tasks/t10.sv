//write a constraint ona 16bit number to generate alternate pair of zeros and ones

class task10;
    rand bit [15:0] val;

    constraint c_val {
        foreach (val[i]) {
          if (i % 2 == 0) {
                (val[i +: 2] == 2'b11 && val[i+2 +: 2] == 2'b00) || (val[i +: 2] == 2'b00 && val[i+2 +: 2] == 2'b11);
            }
        }
    }
endclass

module task10_tb;
    task10 r;
    initial begin
        r = new();
      repeat (3) begin
            r.randomize();
            $display("val = %b \t0x%0h", r.val,r.val);
        end
    end
endmodule

// # KERNEL: val = 1100110011001100 	0xcccc
// # KERNEL: val = 1100110011001100 	0xcccc
// # KERNEL: val = 1100110011001100 	0xcccc