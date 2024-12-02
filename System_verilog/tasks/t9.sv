module tb();
    int arr1[512];
    logic[8:0] address;
    
    task myTask(ref int arr[512], ref logic[8:0] addr);
        for(int i = arr.size(); i >= 0; i= i - 1) begin
            print_int(arr[i]);
        end
    endtask
    
    function void print_int(int val);
        $display("%0t: Value = %0d", $time, val);
    endfunction
    
    initial begin
        
    end
endmodule