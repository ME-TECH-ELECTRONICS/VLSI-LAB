module FIFO (
    input clk,
    input rst,
    input soft_rst,
    input wr_en,
    input rd_en,
    input lfd_state,
    input[7:0] din,
    output full,
    output empty,
    output reg[7:0] dout
);
    reg[8:0] mem [15:0];   // 9-bit wide memory, 16 deep
    reg[3:0] wr_ptr, rd_ptr, count;  // 4-bit pointers and counter
    reg[6:0] intCount;
    integer i;

    // Reset and counting algorithm
    always @(posedge clk) begin
        if(!rst) begin
            dout <= 0;
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            for(i = 0; i < 16; i = i + 1) begin
                mem[i] <= 0;
            end
        end
        if(soft_rst)
            dout <= 8'bx;
    end

    assign full = (count == 16);  // Full when all 16 positions are occupied
    assign empty = (count == 0);  // Empty when count is zero

    // Write operation
    always @(posedge clk) begin
        if (rst && !soft_rst) begin
            if (wr_en && !full) begin
                mem[wr_ptr] <= {lfd_state, din};  // Write lfd_state and data 110101010
                wr_ptr <= wr_ptr + 1;
                count <= count + 1; 
            end
        end
    end

    // Read operation
    always @(posedge clk) begin
        if (rst && !soft_rst) begin
            if (rd_en && !empty) begin
                if(mem[rd_ptr][8] == 1'b1) begin
                    intCount = mem[rd_ptr][7:2] + 1'b1;
                end
                else if(intCount != 0) begin
                    intCount = intCount - 1;
                end
                dout <= mem[rd_ptr][7:0];         // Read only the data part
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;      // Wrap around the read pointer
            end
        end
    end
endmodule


module FIFO_TB();
    reg clk=0,rst;
    reg wr_en,rd_en,soft_rst, lfd_state;

    reg [7:0] din;
    wire [7:0] dout;
    wire full,empty;

    fifo dut(clk, rst, soft_rst, wr_en, rd_en, lfd_state, din, full, empty, dout);
    always #5 clk = ~clk;
    integer i,j;
    initial begin
        rst = 0; #10;
        rst = 1;
        soft_rst = 1;
        wr_en = 0; rd_en = 0; din = 8'b0;
        #10;
        wr_en =1; 
        soft_rst = 0; lfd_state = 1;
        for (i = 0; i<15; i=i+1) begin
            din = $urandom_range(0, 255); 
		  #10;
		  lfd_state = 0;
        end
         wr_en =0; rd_en = 1;
        for (j = 0; j<16; j=j+1) begin
            $display("D[%d]: %h", j, dout);
		  #10;
        end
    end
endmodule