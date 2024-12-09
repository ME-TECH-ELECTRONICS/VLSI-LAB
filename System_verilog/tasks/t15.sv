//15. Write a constraints for genrating numbers in ascending order
class task15;
    rand int num;          
    int prev_num = 0;      
    constraint ascending_c {
      num >= prev_num + 1;  
      num <= 100;           
    }
    task generate_num();
        if (this.randomize()) begin
            $display("%0d", num); 
            prev_num = num;       
        end else begin
            $fatal("Randomization failed!");
        end
    endtask
endclass

module task15_tb;
    task15 asc_gen = new();  
    initial begin
        for (int i = 0; i < 10; i++) begin
            asc_gen.generate_num();  
        end 
        $finish;
    end
endmodule

// OUTPUT
// # KERNEL: 77
// # KERNEL: 80
// # KERNEL: 83
// # KERNEL: 91
// # KERNEL: 97
// # KERNEL: 100