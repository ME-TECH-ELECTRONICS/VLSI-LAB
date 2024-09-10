module task_prog (
    input[7:0] num,
    output reg[15:0] data
);
    task factroial_num;
        input[7:0] n;
        output[15:0] result;
        integer i;
        begin
            for (i = 0; i<n; i=i+1) begin
              result = result * i;        
            end 
        end
    endtask
endmodule