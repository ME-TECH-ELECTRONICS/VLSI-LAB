class myClass;
    rand int a;
    rand int b;

    constraint a_con { a > 5; }
    constraint b_con { b < 10; }
    function void dis_con();
        a_constraint.constraint_mode(0); 
    endfunction

    function void en_con();
        a_con.constraint_mode(1); 
    endfunction
endclass

module testbench;
    initial begin
        MyClass obj = new();
        obj.dis_con();
        if (obj.randomize()) begin
            $display("Randomization successful.");
        end else begin
            $display("Randomization failed.");
        end
    end
endmodule