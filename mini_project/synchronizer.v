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
    
    always @(*) begin 
        case(tmp_din)
            2'b00: begin
                fifo_full <= full_0;
                if(wr_en_reg)
                    wr_en <= 3'b001;
                else
                    wr_en <= 0;
            end
            2'b01: begin
                fifo_full <= full_1;
                if(wr_en_reg)
                    wr_en <= 3'b010;
                else
                    wr_en <= 0;
                    
            end
            2'b10: begin
                fifo_full <= full_2;
                if(wr_en_reg)
                    wr_en <= 3'b100;
                else
                    wr_en <= 0;
            end
            default: begin 
                fifo_full <= 0;
                wr_en <= 0;
            end
        endcase
    end
    
    assign vld_out_0 = ~empty_0;
    assign vld_out_1 = ~empty_1;
    assign vld_out_2 = ~empty_2;
    
    always @(posedge clk) begin
        if(!rst) begin 
            count0 <= 0;
            soft_reset_0 <= 0;
        end
        if(vld_out_0) begin 
            if(!rd_en_0) begin 
                if(count0 == 29) begin
                    soft_reset_0 <= 1;
                    count0 <= 0;
                end
                else begin
                    soft_reset_0 <= 0;
                    count0 <= count0 + 1;
                end
            end
            else 
                count0 <= 0;
        end
    end
    
    always @(posedge clk) begin
        if(!rst) begin 
            count1 <= 0;
            soft_reset_1 <= 0;
        end
        if(vld_out_1) begin 
            if(!rd_en_1) begin 
                if(count1 == 29) begin
                    soft_reset_1 <= 1;
                    count1 <= 0;
                end
                else begin
                    soft_reset_1 <= 0;
                    count1 <= count1 + 1;
                end
            end
            else 
                count1 <= 0;
        end
    end
    
    always @(posedge clk) begin
        if(!rst) begin 
            count2 <= 0;
            soft_reset_2 <= 0;
        end
        if(vld_out_2) begin 
            if(!rd_en_2) begin 
                if(count2 == 29) begin
                    soft_reset_2 <= 1;
                    count2 <= 0;
                end
                else begin
                    soft_reset_2 <= 0;
                    count2 <= count2 + 1;
                end
            end
            else 
                count2 <= 0;
        end
    end
endmodule


module sync_tb();
    reg clk = 0, rst, detect_addr, full_0, full_1, full_2, empty_0, empty_1, empty_2, wr_en_reg, rd_en_0, rd_en_1, rd_en_2;
    reg[1:0] din;
    
    wire fifo_full, vld_out_0, vld_out_1, vld_out_2, soft_reset_0, soft_reset_1, soft_reset_2;
    wire[2:0] wr_en;
    
    synchronizer dut(clk, rst, din,detect_addr, full_0, full_1, full_2, empty_0, empty_1, empty_2, wr_en_reg, rd_en_0, rd_en_1, rd_en_2, wr_en, fifo_full, vld_out_0, vld_out_1, vld_out_2, soft_reset_0, soft_reset_1, soft_reset_2);
    
    always #5 clk = ~clk;

    initial begin
        rst = 0;
        detect_addr = 0;
        full_0 = 0;
        full_1 = 0;
        full_2 = 0;
        empty_0 = 0;
        empty_1 = 0;
        empty_2 = 0;
        wr_en_reg = 0;
        rd_en_0 = 0;
        rd_en_1 = 0;
        rd_en_2 = 0;
        din = 0;
        #10;
        rst = 1;
        #10;
    end
    
    
endmodule