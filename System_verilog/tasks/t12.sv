//12. gentrate the below pattern
// 1
// 11
// 111
// 1111
// 11111
// 111111
// 1111111
// 11111111
// 111111111

class PatternGen;
    rand int num_rows;
    function new();
        num_rows = 9;
    endfunction
    constraint con1t {
        num_rows inside {[1:9]};
    }

    function void generate_pyramid();
        int i;
        string row_pattern;
        for (i = 1; i <= num_rows; i++) begin
            row_pattern = {i{"1"}};  
            $display("%s", row_pattern);
        end
    endfunction
  endclass

module pattern_generator;
    initial begin
        PatternGen gen;
        gen = new();
        gen.generate_pyramid();
    end
endmodule


// # KERNEL: 1
// # KERNEL: 11
// # KERNEL: 111
// # KERNEL: 1111
// # KERNEL: 11111
// # KERNEL: 111111
// # KERNEL: 1111111
// # KERNEL: 11111111
// # KERNEL: 111111111