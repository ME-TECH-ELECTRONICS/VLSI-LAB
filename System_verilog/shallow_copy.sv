class first;
   int data = 12;
endclass

class second;
    first f1;
    int ds = 1;
    function new();
        f1 = new();
    endfunction 
endclass 


module shallow_copy_tb();
    second s1,s2;
    initial begin
        s1 = new();
        s1.ds = 25;
        s2 = new s1;
        $display("S1_DS: %0d", s1.ds);
        s2.ds = 46;
        $display("S1_DS: %0d", s1.ds);
        s2.f1.data = 20;
        $display("S1_DS: %0d, S1_F1_DATA: %0d", s1.ds, s1.f1.data);
    end
endmodule