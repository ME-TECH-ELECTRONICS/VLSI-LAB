module register (
    input clk,
    input rst,
    input pkt_valid,
    input[7:0] din,
    input fifo_full,
    input detect_addr,
    input ld_state,
    input laf_state,
    input full_state,
    input lfd_state,
    input rst_int_reg,
    output err,
    output parity_done,
    output low_pkt_valid
);
    reg [7:0] header, int_reg, int_parity, ext_parity;
    always @(posedge clk) begin
        if(!rst) 
            parity_done <= 0;
        else if (detect_addr)
            parity_done <= 0;
        else if((ld_state && (~fifo_full) && (~pkt_valid)) || (laf_state && low_pkt_valid && (~parity_done)))
            parity_done <= 1;
    end

    always @(posedge clk) begin
        if (!rst) begin
            low_pkt_valid <= 0;
        else if (rst_int_reg) 
            low_pkt_valid <= 0;
        else if (ld_state && ~pkt_valid)
            low_pkt_valid <= 1; 
        end
    end
    always @(posedge clk) begin
        if(!rst) begin
            
        end
    end
endmodule