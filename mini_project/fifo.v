module FIFO (
    input clk,
    input rst,
    input soft_rst,
    input wr_en,
    input rd_en,
    input lfd_state,
    input[7:0] din,
    output full,
    output  empty,
    output reg[7:0] dout
);
    reg[8:0] mem [15:0];
    reg[3:0] wr_ptr, rd_ptr, count;
    integer i;
    
    //Reset and counting algorithm
    always @(posedge clk) begin
        if(!rst || soft_rst) begin
            dout = 0;
            wr_ptr = 0;
            rd_ptr = 0;
            count = 0;
            for(i=0;i<16;i=i+1) begin
                mem[i] = 0;
            end
        end
        else begin
            if (wr_en && !full && rd_en && !empty) begin
                count <= count;   // When both read and write occur simultaneously
            end else if (wr_en && !full) begin
                count <= count + 1;  // Increment count on write
            end else if (rd_en && !empty) begin
                count <= count - 1;  // Decrement count on read
            end
        end
    end
    
    assign full = (count == 15);
    assign empty = (count == 0);
    
    //Write operation
    always @(posedge clk) begin
        if(rst || !soft_rst) begin
            if (wr_en && !full) begin
                mem[wr_ptr] <= {lfd_state, din};
                wr_ptr = wr_ptr + 1;
            end
        end
    end
    
    //Read operation
    always @(posedge clk) begin
        if(rst || !soft_rst) begin
            if (rd_en && !empty) begin
                dout = mem[rd_ptr][7:0];
                rd_ptr = rd_ptr + 1;
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

    FIFO dut(clk, rst, soft_rst, wr_en, rd_en, lfd_state, din, full, empty, dout);
    always #5 clk = ~clk;
    integer i,j;
    initial begin
        rst = 0; #10;
        rst = 1;
        soft_rst = 0;
        wr_en = 0; rd_en = 0; din = 8'b0;
        #10;
        wr_en =1; lfd_state = 1;
        soft_rst = 1
        for (i = 0; i<15; i=i+1) begin
            din = $urandom_range(0, 255);
            lfd_state = 0;
		  #10;
        end
        rd_en = 1;
        for (j = 0; j<15; j=j+1) begin
            $display("D[%d]: %h", j, dout);
		  #10;
        end
    end
endmodule