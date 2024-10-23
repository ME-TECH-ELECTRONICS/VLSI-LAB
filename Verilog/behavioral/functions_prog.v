module fibonacci_function;

  reg [31:0] n;
  reg [31:0] fib;
  integer i;
  
  // Function to calculate Fibonacci number
  function [31:0] fibonacci;
    input [31:0] num;
    integer j;
    reg [31:0] a, b, temp;
    begin
      a = 0;
      b = 1;
      if (num == 0) begin
        fibonacci = a;
      end else if (num == 1) begin
        fibonacci = b;
      end else begin
        for (j = 2; j <= num; j = j + 1) begin
          temp = a + b;
          a = b;
          b = temp;
        end
        fibonacci = b;
      end
    end
  endfunction
  
  initial begin
    // Number of Fibonacci terms to display
    n = 10; 
    // Display Fibonacci series
    $display("Fibonacci series up to %0d terms:", n);
    for (i = 0; i < n; i = i + 1) begin
      fib = fibonacci(i);
      $display("Fib(%0d) = %0d", i, fib);
    end
  end
endmodule
