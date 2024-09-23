module ram_16x8_SP (
    input clk,
    input rst,
    input RW_en,
    input [3:0] addr,
    input [7:0] din,
    output reg [7:0] dout
);

    reg [7:0] mem [15:0];
    integer i;
    always @(posedge clk) begin
        if(!rst) begin
            for (i = 0; i<16; i=i+1) begin
                mem[i] = 0;
            end
        end
        else begin
            if(!RW_en) begin
                mem[addr] = din;
            end
            else begin
                dout = mem[addr];
            end
        end
    end
endmodule

module ram_16x8_SP_tb ();
    reg clk=0,rst;
    reg RW_en;
    reg [3:0] addr;
    reg [7:0] din;
    wire [7:0] dout;
    ram_16x8_SP dut(clk,rst,RW_en,addr,din,dout);
    always #5 clk = ~clk;
    integer i;
    initial begin
        rst = 0; #10;
        rst = 1; 
        RW_en = 0;
        for (i = 0; i<16; i=i+1) begin
            addr = i;
            din = $urandom_range(0, 255);
		#10;
        end
        RW_en = 1;
        for (i = 0; i<16; i=i+1) begin
            addr = i;
	    #10;
        end
    end
endmodule