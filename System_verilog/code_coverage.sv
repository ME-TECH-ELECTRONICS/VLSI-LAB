// ====run.do======//
// vsim +access+r;
// run -all;
// acdb save;
// acdb report -db  fcover.acdb -txt -o cov.txt -verbose  
// exec cat cov.txt;
// exit

module top (
    input[1:0] a,
    input[1:0] b
);
  assign b = a;  
endmodule

module tb;
    reg[1:0] a;
    reg[1:0] b;  
    integer i = 0;
    top dut(a, b);
    covergroup covg;
        coverpoint a;
        coverpoint b;
    endgroup

    covg c = new();
    initial begin
      for (i = 0; i < 65535; i = i + 1) begin
          a = $urandom();
          c.sample();
          #10;
        end
    end 
    initial begin
       #500;
       $finish();
    end
endmodule