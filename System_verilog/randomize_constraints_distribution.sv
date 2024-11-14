class myClass;
  rand bit[1:0] var1, var2;
  rand bit var3, var4;
    constraint data {
        var1 dist {0:=30, [1:3]:=90};
      	var2 dist {0:/30, [1:3]:/90};
        (var3 == 0) -> (var4 == 0);
    }
endclass //myClass

module tb ();
    myClass c;
    initial begin
        c = new();
        repeat(5) begin
            c.randomize();
            $display("var1: %0d var2: %0d var3: %0d var4: %0d", c.var1, c.var2, c.var3, c.var4);
        end
    end
endmodule