`include "environment.sv"
`include "interface.sv"
module tb;
    intf i_intf();
    environment env;
    andgate dut(i_intf.a,i_intf.b,i_intf.c);
    initial begin
        env=new(i_intf);
        env.gen.repeat_cnt=10;
        env.run();
    end
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule