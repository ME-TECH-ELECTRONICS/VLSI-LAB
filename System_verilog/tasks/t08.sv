// write a sv program to randomize 32bit variable but only randomize the 20th bit

class task8;
    randc bit pos;
    int num = 32'hffffffff;
    function void post_randomize;
      num[20] = pos;  
    endfunction

    
endclass

module task8_tb;
    int result;
    task8 r;

    initial begin
        r = new();
        repeat(3) begin 
            r.randomize();
            $display("number: %0b \t 0x%0h", r.num, r.num);
        end
    end
endmodule

// # KERNEL: number: 11111111111011111111111111111111 	 0xffefffff
// # KERNEL: number: 11111111111111111111111111111111 	 0xffffffff
// # KERNEL: number: 11111111111011111111111111111111 	 0xffefffff