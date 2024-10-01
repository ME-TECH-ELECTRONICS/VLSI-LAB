module FIFO_0 (
    input clk,
    input rst,
    input soft_rst,
    input wr_en,
    input rd_en,
    input ldf_state
    input[7:0] din,
    output reg full,
    output reg empty,
    output reg[7:0] dout
);
    reg[8:0] mem [15:0];
    reg[3:0] wr_ptr, rd_ptr, count;
    integer i;
    
    //Reset and counting algorithm
    always @(posedge clk) begin
        if(!rst) begin
            dout = 0;
            wr_ptr = 0;
            rd_ptr = 0;
            full = 0;
            empty = 1;
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
        if(rst) begin
            if (wr_en && !full) begin
                mem[wr_ptr] = din;    
                if(wr_ptr == 4'd15) begin
                    wr_ptr = 0;
                end
                wr_ptr = wr_ptr + 1;
            end
        end
    end
    
    //Read operation
    always @(posedge clk) begin
        if(rst) begin
            if (rd_en && !empty) begin
                dout = fifo_mem[rd_ptr];   
                if(rd_ptr == 4'd15) begin
                    rd_ptr = 0;
                end
                rd_ptr = rd_ptr + 1;
            end
        end
    end
endmodule