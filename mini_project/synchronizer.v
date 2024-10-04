module synchronizer (
    input clk, 
    input rst,
    input[1:0] din,
    input detect_addr,
    input full_0,
    input full_1,
    input full_2,
    input empty_0,
    input empty_1,
    input empty_2,
    input wr_en_reg,
    input rd_en_0,
    input rd_en_1,
    input rd_en_2,
    output reg[2:0] wr_en,
    output reg fifo_full,
    output vld_out_0,
    output vld_out_1,
    output vld_out_2,
    output reg soft_reset_0,
    output reg soft_reset_1,
    output reg soft_reset_2
);

    reg[4:0] count0, count1, count2;
    reg[1:0] tmp_din;
    
    always @(posedge clk) begin 
        if(!rst)
            tmp_din <= 0;
        if(detect_addr)
            tmp_din <= din;
    end
    
endmodule