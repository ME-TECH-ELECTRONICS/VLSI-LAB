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
    integer i;

    // Reset and counting algorithm
    always @(posedge clk) begin
        if(!rst || soft_rst) begin
            dout <= 0;
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            for(i = 0; i < 16; i = i + 1) begin
                mem[i] <= 0;
            end
        end else begin
            if (wr_en && !full && rd_en && !empty) begin
                count <= count;  // No change in count when both read and write happen simultaneously
            end else if (wr_en && !full) begin
                count <= count + 1;  // Increment count on write
            end else if (rd_en && !empty) begin
                count <= count - 1;  // Decrement count on read
            end
        end
    end

    assign full = (count == 16);  // Full when all 16 positions are occupied
    assign empty = (count == 0);  // Empty when count is zero

    // Write operation
    always @(posedge clk) begin
        if (rst && !soft_rst) begin
            if (wr_en && !full) begin
                mem[wr_ptr] <= {lfd_state, din};  // Write lfd_state and data
                wr_ptr <= (wr_ptr + 1) % 16;      // Wrap around the write pointer
            end
        end
    end

    // Read operation
    always @(posedge clk) begin
        if (rst && !soft_rst) begin
            if (rd_en && !empty) begin
                dout <= mem[rd_ptr][7:0];         // Read only the data part
                rd_ptr <= (rd_ptr + 1) % 16;      // Wrap around the read pointer
            end
        end
    end
endmodule