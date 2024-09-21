module sys_tasks (
    input[7:0] num,
    output reg[15:0] data
);
    always @(*) begin
        data = num ** 2;
    end
endmodule

module sys_tasks_tb ();
    reg [7:0] num;
    wire [15:0] data;
    sys_tasks dut (num, data);
    initial begin
        num = 5;
        #10;
        $display("Square of %0d is %0d", num, data);
        $monitor($time, "data=%0d", data);
        #10
        
        $finish;
    end
endmodule