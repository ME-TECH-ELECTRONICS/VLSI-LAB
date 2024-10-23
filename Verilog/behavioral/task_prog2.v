module factorial_task;

  reg [31:0] num;
  reg [31:0] result;
  
  // Task to calculate factorial
  task factorial;
    input [31:0] in;
    output [31:0] out;
    integer i;
    begin
      out = 1;
      for (i = 1; i <= in; i = i + 1) begin
        out = out * i;
      end
    end
  endtask
  
  initial begin
    num = 5;  
    factorial(num, result);
    $display("The factorial of %0d is %0d", num, result);
  end

endmodule
