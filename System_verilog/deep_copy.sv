class first;
    int data = 10;
    function first copy();
        copy = new();
        copy.data = data;
    endfunction 
endclass 

class second;
    int ds = 56;
    first f1;
    
    function new();
        f1 = new();
    endfunction
    
    function second copy();
        copy = new();
        copy.ds = ds;
        copy.f1 = f1.copy();
    endfunction
endclass

module tb();
    second s1, s2;
    initial begin 
        s1 = new();
        s2 = new();
        s1.ds = 34;
        s2 = s1.copy();
      $display("S2_DS: %0d", s2.ds);
        s2.ds = 26;
      $display("S1_DS: %0d", s1.ds);
        s2.f1.data = 68;
      $display("S1_F1_DATA: %0d", s2.f1.data);    
    end
endmodule