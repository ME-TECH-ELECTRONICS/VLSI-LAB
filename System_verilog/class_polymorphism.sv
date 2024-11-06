class first;
    int data = 12;
    
    virtual function void print();
        $display("FIRST_VAL: %0d", data);
    endfunction
endclass

class second extends first;
    int temp = 34;
    
    function void add();
      $display("SECOND_VAL_ADD: %0d", super.data + 4);
    endfunction

    function void print();
        $display("SECOND_VAL: %0d", temp);
    endfunction
endclass 

module tb ();
    first f;
    second s;
    initial begin
        f = new();
        s = new();
        f = s;
        f.print();
        s.add();
    end
endmodule