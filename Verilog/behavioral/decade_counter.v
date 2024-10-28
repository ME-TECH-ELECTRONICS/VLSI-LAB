module decade_counter (
    input clk,
    input rst,
    output reg[3:0] q
);
    always @(posedge clk ) begin
        if (rst)
            q <= 0;
        else begin 
            if(q >= 4'b1001) 
                q <= 0;
            else 
                q <= q+1;
        end
    end
endmodule

module decade_counter_tb ();
    reg clk=0, rst;
    wire[3:0] q;
    decade_counter dut (clk,rst,q);
    always #5 clk = ~clk;
    initial begin
        rst = 1; #10;
        rst = 0; #10;
    end
    initial begin
        $dumpfile("out.vcd");
        $dumpvars(1);
        #1000; $finish;
    end
endmodule