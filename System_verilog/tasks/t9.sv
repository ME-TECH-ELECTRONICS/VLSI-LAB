module tb();
    int arr1[512];
    logic[8:0] address;
    
    task myTask(ref int arr[512], ref logic[8:0] addr);
        for(int i = arr.size(); i >= 0; i= i - 1)
    
    endtask
endmodule