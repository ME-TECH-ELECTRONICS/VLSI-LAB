//12. gentrate the below pattern
//1
//12
//123
//1234
//12345
//123456
//1234567
//12345678
//123456789

class PatternGen;
    rand int num_rows;
    function new();
        num_rows = 9;
    endfunction
    constraint con1t {
        num_rows inside {[1:9]};
    }

    function void generate_pattern();
        int i, j;
        string row_pattern;

        for (i = 1; i <= num_rows; i++) begin
            row_pattern = "";
            for (j = 1; j <= i; j++) begin
              row_pattern = {row_pattern, $sformatf("%0d", j)};
            end
            $display("%s", row_pattern);
        end
    endfunction
  endclass

module pattern_generator;
    initial begin
        PatternGen gen;
        gen = new();
        gen.generate_pattern();
    end
endmodule


// # KERNEL: 1
// # KERNEL: 12
// # KERNEL: 123
// # KERNEL: 1234
// # KERNEL: 12345
// # KERNEL: 123456
// # KERNEL: 1234567
// # KERNEL: 12345678
// # KERNEL: 123456789