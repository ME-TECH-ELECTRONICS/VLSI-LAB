module testbench ();
  bit[7:0] arr[5];
  bit[5:0] arr1; 

    initial begin
      arr[1] = 1;
      arr1[2] = 1;
      $display("size of arr = %0d, arr1 = %0d", $size(arr),$size(arr1));
      $display("size of arr = %0p, arr1 = %0p", arr, arr1);

    end
endmodule