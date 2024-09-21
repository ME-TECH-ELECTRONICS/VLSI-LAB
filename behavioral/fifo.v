module fifo (
    input clk,
    input reset,
    input [7:0] data_in,
    input write_en,
    input read_en,
    output reg[7:0] data_out
    output reg full,
    output reg empty
);
    // memmory elemnt for 16x8 storage
    reg [7:0] mem [15:0];
    reg[3:0] w_addr = 0, r_addr = 0;
    // fifo status  
    always @(posedge clk) begin
        if (reset) begin
            full <= 0;
            empty <= 1;
            data_out <= 0;
            for (integer i = 0; i<16; i= i+1) begin
                mem[i] <= 0;
            end
        end
        else begin
            if (write_en && !full) begin
                mem[w_addr] <= data_in;
                w_addr <= w_addr + 1;
            end
            if (read_en && !empty) begin
                data_out <= mem[r_addr];
                r_addr <= r_addr + 1;
            end
        end
        if (w_addr == r_addr) begin 
            empty <= 1;
            full <= 0;
        end
        else if (w_addr == r_addr+1) begin 
            empty <= 0; 
            full <= 1;
        end
        else begin
            empty <= 0;
            full <= 0;
        end    
    end
endmodule