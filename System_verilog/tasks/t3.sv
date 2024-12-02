//write a constraint such that even location contains odd number and odd location consits of even numbers

class task2;
    rand bit[6:0] odd;
    rand bit[6:0] even;

    constraint con1 {
        odd >= 20 && odd <= 100 && odd % 2 == 0;
        even >= 20 && even <= 100 && even % 2 == 1;
    }
endclass //0001

module task1_tb;
        task2 t2;
    initial begin
        t2 = new();

        repeat(5) begin
            t2.randomize();
            $display("ODD: %0d", t2.odd);
            $display("EVEN: %0d", t2.even);
            $display("=======================");
        end
    end
endmodule