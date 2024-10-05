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
    output reg[7:0] dout,
    output reg err,
    output reg parity_done,
    output reg low_pkt_valid
);
    reg [7:0] header, int_reg, int_parity, ext_parity;

    //PARITY DONE LOGIC
    always @(posedge clk) begin
        if(!rst) 
            parity_done <= 0;
        else if (detect_addr)
            parity_done <= 0;
        else if((ld_state && (~fifo_full) && (~pkt_valid)) || (laf_state && low_pkt_valid && (~parity_done)))
            parity_done <= 1;
    end

    //LOW PACKET VALID LOGIC
    always @(posedge clk) begin
        if (!rst) begin
            low_pkt_valid <= 0;
        else if (rst_int_reg) 
            low_pkt_valid <= 0;
        else if (ld_state && ~pkt_valid)
            low_pkt_valid <= 1; 
        end
    end

    //DATA OUT LOGIC
    always @(posedge clk) begin
        if(!rst) begin
            dout <= 0;
            header <= 0;
            int_reg <= 0;
        end
        else if(detect_addr && pkt_valid && din !=2'b11)
            header <= din
        else if(lfd_state)
            dout <= header;
        else if(ld_state && ~fifo_full)
            dout <= din;
        else if(ld_state && fifo_full)
            int_reg <= din;
        else if(laf_state)
            dout <= int_reg; 
    end

    //PARITY CALCULATE LOGIC
    always @(posedge clk) begin
        if (!rst)
            int_parity <= 0;
        else if (detect_addr)
            int_parity <= 0;
        else if(lfd_state && pkt_valid)
                int_parity <= int_parity ^ header;
            else if(ld_state && pkt_valid && ~full_state)
                int_parity <= int_parity ^ din;
            else
                int_parity <= int_parity;
        end

    //ERROR LOGIC
    always@(posedge clock) begin
        if(!resetn)
            err<=0;
        else if(parity_done)begin
            if (int_parity == ext_parity)
                err <= 0;
            else 
                err <= 1;
        end else
            err <= 0;
    end

    //EXTERNAL PARITY LOGIC
    always@(posedge clock) begin
        if(!resetn)
            ext_parity <= 0;
        else if(detect_add)
            ext_parity <= 0;
        else if((ld_state && !fifo_full && ~pkt_valid) || (laf_state && ~parity_done && low_packet_valid))
            ext_parity <= data_in;
        end
endmodule