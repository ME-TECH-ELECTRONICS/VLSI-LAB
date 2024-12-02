module tb();
    int arr1[512];
    logic[8:0] address;
    
    task myTask(ref int arr[512], ref logic[8:0] addr);
        print_int(arr[addr]);
    endtask
    
    function void print_int(int val);
        $display("%0t: Value = %0d", $time, val);
    endfunction
    
    initial begin
        
        for(int i = 510; i >= 0; i= i - 1) begin
            arr1[i] = $urandom_range(20, 255);
        end
        arr1[511] = 5;
        address = $urandom();
        
        myTask(arr1, address);
        
    end
endmodule