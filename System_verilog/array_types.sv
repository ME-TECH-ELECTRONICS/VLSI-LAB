module array_types();
    int arr[3] = {20,40,34};
    string arr1[3] = {"Hello","World","!"};
    string arr2[];
    int arr3[string];
    
    initial begin
        arr2 = new[4];
        arr2 = {"Hello","vlsi","world"};
        arr3["RED"] = 128;
        arr3["GREEN"] = 230;
        arr3["BLUE"] = 10;
        $display("/**** Simple Integer Array ****/");
        foreach(arr[i]) begin 
            $display("arr[%0d]: %0d",i, arr[i]);
        end
        $display("/**** Simple String Array ****/");
        foreach(arr1[i]) begin 
            $display("arr1[%0d]: %0s",i, arr1[i]);
        end
        $display("/**** Dynamic Array ****/");
        foreach(arr2[i]) begin 
            $display("arr2[%0d]: %0s",i, arr2[i]);
        end
        $display("/**** Associative Array ****/");
        foreach(arr3[i]) begin 
            $display("arr3[%0s]: %0d",i, arr3[i]);
        end
        
        
    end
endmodule