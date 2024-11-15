class myClass;
  rand bit[1:0] var1, var2;
  rand bit var3, var4, var5, var6, var7, var8;
    constraint data {
        var1 dist {0:=30, [1:3]:=90};
      	var2 dist {0:/30, [1:3]:/90};
        (var3 == 0) -> (var4 == 0);
        (var5 == 0) <-> (var6 == 1);
    }
    constraint d {
        if (var7==1) {
            var8 == 0;
        } else {
            var8 == 1;
        }
    }
endclass //myClass

module tb ();
    myClass c;
    initial begin
        c = new();
            $display("====================================================");
        repeat(3) begin
            c.randomize();
            $display("var1: %0d var2: %0d //Same weight for specified val", c.var1, c.var2);
            $display("var3: %0d var4: %0d //Equally disribute weight", c.var3, c.var4);
            $display("var5: %0d var6: %0d //implicit operator", c.var5, c.var6);
            $display("var7: %0d var8: %0d //mutally Exclusive", c.var7, c.var8);
            $display("====================================================");
        end
    end
endmodule