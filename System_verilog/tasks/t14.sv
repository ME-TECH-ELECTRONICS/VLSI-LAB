//14. generate the below pattern
//123456789
//12345678
//1234567
//123456
//12345
//1234
//123
//12
//1

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

        for (i = num_rows; i > 0; i--) begin
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

//OUTPUT
// # KERNEL: 123456789
// # KERNEL: 12345678
// # KERNEL: 1234567
// # KERNEL: 123456
// # KERNEL: 12345
// # KERNEL: 1234
// # KERNEL: 123
// # KERNEL: 12
// # KERNEL: 1