module ram_16x8_DP (
    input clk,
    input rst,
    input rd_en,
    input wr_en,
    input [3:0] wr_addr,
    input [3:0] rd_addr,
    input [7:0] din,
    output reg [7:0] dout
);
    integer i;
	reg [7:0] mem [15:0]; 

    always @(posedge clk) begin
        if(!rst) begin
            dout <= 0;
            for (i = 0; i<16; i=i+1) begin
            	mem[i] <= 0;
            end
        end
        else  begin
            if(wr_en) begin
                mem[wr_addr] <= din;
            end
        end 
    end
    always @(posedge clk) begin
        if (!rst) begin
            dout <= 0;
            for (i = 0; i<16; i=i+1) begin
            	mem[i] <= 0;
            end
        end
        else begin
            if(rd_en) begin
                dout <= mem[rd_addr];
            end 
        end
    end
endmodule

module ram_16x8_DP_tb ();
    reg clk=0,rst;
    reg rd_en,wr_en;
    reg [3:0] wr_addr, rd_addr;
    reg [7:0] din;
    wire [7:0] dout;

    ram_16x8_DP dut(clk,rst,rd_en,wr_en,wr_addr,rd_addr,din,dout);
    always #5 clk = ~clk;
    integer i,j;
    initial begin
        rst = 0; #10;
        rst = 1;
        wr_en = 1;
        for (i = 0; i<16; i=i+1) begin
            wr_addr = i;    
            din = $urandom_range(0, 255);
		    #10;
        end
    end
    initial begin
        #25;
        rd_en = 1;
        for (j = 0; j<16; j=j+1) begin
            rd_addr = j;
	        #10;
            $display("mem[%0h]: %0h", rd_addr, dout);
        end
    end
    initial begin
        $dumpfile("out.vcd");
        $dumpvars(1);
        #1000; $finish;
    end 
endmodule