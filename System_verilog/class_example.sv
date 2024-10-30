class mainClass;
  int value;

  function new(int val);
    value = val;
  endfunction
endclass

//object declaration
mainClass obj1;
mainClass obj2;

module shallow_copy_example;
  initial begin
    obj1 = new(10);
    obj2 = new obj1;

    
    $display("Author: MELVIN RIJOHN T");
    $display("Before modification:");
    $display("obj1 value = %0d", obj1.value);
    $display("obj2 value = %0d", obj2.value);

    obj2.value = 20;

    $display("\nAfter modifying obj2 value:");
    $display("obj1 value = %0d", obj1.value);
    $display("obj2 value = %0d", obj2.value);
  end
endmodule
