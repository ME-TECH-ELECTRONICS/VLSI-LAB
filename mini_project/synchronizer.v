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
endmodule