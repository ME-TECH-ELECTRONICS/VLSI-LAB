module square_task;

  reg [31:0] num;
  reg [31:0] result;
  
  // Task to calculate square
  task square;
    input [31:0] in;
    output [31:0] out;
    begin
      out = in * in;
    end
  endtask
  
  initial begin
    num = 5;  // Change this number to calculate square of other values
    square(num, result);
    $display("The square of %0d is %0d", num, result);

  end
endmodule
