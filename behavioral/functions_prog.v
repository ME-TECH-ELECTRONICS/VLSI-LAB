module functions_prog (
    input[3:0] num,
    output reg[15:0] val
);
    function [15:0] square_num ;
        input [7:0] n;
        begin
           square_num = n ** 2; 
        end
    endfunction

    always @(*) begin
        val = square_num(num);
    end
endmodule

module functions_prog_tb ();
    reg[7:0] num;
    wire[15:0] val;

    functions_prog dut(num,val);
    initial begin
        num = 5;
        #10 $display("Square of %0d is %0d", num, val);
        $finish;
    end
endmodule