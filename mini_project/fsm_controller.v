module fsm_controller(
    input clk,
    input rst,
    input pkt_valid,
    input fifo_full,
    input fifo_empty_0,
    input fifo_empty_1,
    input fifo_empty_2,
    input soft_rst_0,
    input soft_rst_1,
    input soft_rst_2,
    input parity_done,
    input low_pkt_valid,
    input[1:0] din,
    output wr_en_req, 
    output detect_addr, 
    output ld_state, 
    output laf_state, 
    output lfd_state,
    output full_state,
    output rst_int_req,
    output busy 
);
//fsm controller for 1x3 router 

    parameter DECODE_ADDRESS     = 3'b000;
    parameter LOAD_FIRST_DATA 	 = 3'b001;
    parameter LOAD_DATA 		 = 3'b010;
    parameter WAIT_TILL_EMPTY 	 = 3'b011;
    parameter CHECK_PARITY_ERROR = 3'b100;
    parameter LOAD_PARITY 		 = 3'b101;
    parameter FIFO_FULL_STATE 	 = 3'b110;
    parameter LOAD_AFTER_FULL 	 = 3'b111;

    reg [2:0] PS, NS;

    always @(posedge clk) begin
        if(!rst)
            PS <= DECODE_ADDRESS;
        else if(soft_rst_0 || soft_rst_1 || soft_rst_2)
            PS <= DECODE_ADDRESS;
        else
            PS <= NS;
    end

    always @(*) begin
        case (PS)
            DECODE_ADDRESS: begin
                if ((pkt_valid && din == 0 && fifo_empty_0) || (pkt_valid && din == 1 && fifo_empty_1) || (pkt_valid && din == 2 && fifo_empty_2))
                    NS = LOAD_FIRST_DATA;
                else if ((pkt_valid && din == 0 && ~fifo_empty_0) || (pkt_valid && din == 1 && !fifo_empty_1) || (pkt_valid && din == 2 && !fifo_empty_2))
                    NS = WAIT_TILL_EMPTY;
                else NS = DECODE_ADDRESS;
            end

            LOAD_FIRST_DATA: NS = LOAD_DATA;

            LOAD_DATA: begin
                if (fifo_full) begin
                    NS = FIFO_FULL_STATE;
                end
                else if (!fifo_full && !pkt_valid) NS = LOAD_PARITY;
                else NS = LOAD_DATA;
            end
            
            WAIT_TILL_EMPTY: begin
                if (fifo_empty_0 || fifo_empty_1 || fifo_empty_2) NS = LOAD_FIRST_DATA;
                else NS = WAIT_TILL_EMPTY;
            end

            FIFO_FULL_STATE: begin
                if (!fifo_full) NS = LOAD_AFTER_FULL;
                else NS = FIFO_FULL_STATE;
            end

            LOAD_AFTER_FULL: begin
                if (!parity_done && !low_pkt_valid) NS = LOAD_DATA;
                else if(!parity_done && low_pkt_valid) NS = LOAD_PARITY;
                else if(parity_done) NS = DECODE_ADDRESS;
            end

            LOAD_PARITY: NS = CHECK_PARITY_ERROR;

            CHECK_PARITY_ERROR: begin
                if (!fifo_full) NS = DECODE_ADDRESS;
                else NS = FIFO_FULL_STATE;
            end

            default: PS = DECODE_ADDRESS;
        endcase
    end
    assign detect_addr  = (PS == DECODE_ADDRESS);
    assign lfd_state    = (PS == LOAD_FIRST_DATA);
    assign busy         = (PS == LOAD_FIRST_DATA) || !(PS == LOAD_DATA) || (PS == LOAD_PARITY) || (PS == FIFO_FULL_STATE) ||(PS == LOAD_AFTER_FULL) || (PS == WAIT_TILL_EMPTY) || (PS == CHECK_PARITY_ERROR);
    assign ld_state     = (PS == LOAD_DATA);
    assign wr_en_req    = (PS == LOAD_DATA) || (PS == LOAD_PARITY) || !(PS == FIFO_FULL_STATE) || (PS == LOAD_AFTER_FULL) || !(PS == WAIT_TILL_EMPTY);
    assign full_state   = (PS == FIFO_FULL_STATE);
    assign laf_state    = (PS == LOAD_AFTER_FULL);
    assign rst_int_req  = (PS == CHECK_PARITY_ERROR);
endmodule


module fsm_tb();
    reg clk, rst, pkt_valid, fifo_full, fifo_empty_0, fifo_empty_1, fifo_empty_2, soft_rst_0, soft_rst_1, soft_rst_2, parity_done, low_pkt_valid; 
    reg[1:0] din;
    wire wr_en_req, detect_addr, lfd_state, laf_state, full_state, rst_int_req, busy;

    fsm_controller uut (
        .clk(clk),
        .rst(rst),
        .pkt_valid(pkt_valid),
        .fifo_full(fifo_full),
        .fifo_empty_0(fifo_empty_0),
        .fifo_empty_1(fifo_empty_1),
        .fifo_empty_2(fifo_empty_2),
        .soft_rst_0(soft_rst_0),
        .soft_rst_1(soft_rst_1),
        .soft_rst_2(soft_rst_2),
        .parity_done(parity_done),
        .low_pkt_valid(low_pkt_valid),
        .din(din),
        .wr_en_req(wr_en_req),
        .detect_addr(detect_addr),
        .ld_state(lfd_state),
        .laf_state(laf_state),
        .full_state(full_state),
        .rst_int_req(rst_int_req),
        .busy(busy)
    );
    always #5 clk = ~clk;   
    
    initial begin
        clk = 0;
        rst = 0;
        pkt_valid = 0;
        fifo_full = 0;
        fifo_empty_0 = 0;
        fifo_empty_1 = 0;
        fifo_empty_2 = 0;
        soft_rst_0 = 0;
        soft_rst_1 = 0;
        soft_rst_2 = 0;
        parity_done = 0;
        low_pkt_valid = 0;
        din = 0;
        #5 rst = 1;
        #10 pkt_valid = 1;
        #10 pkt_valid = 0;
        #10 fifo_full = 1;
        #10 fifo_full = 0;
        #10 fifo_empty_0 = 1;
        #10 fifo_empty_0 = 0;
        #10 fifo_empty_1 = 1;
        #10 fifo_empty_1 = 0;
        #10 fifo_empty_2 = 1;
        #10 fifo_empty_2 = 0;
        #10 soft_rst_0 = 1;
        #10 soft_rst_0 = 0;
        #10 soft_rst_1 = 1;
        #10 soft_rst_1 = 0;
        #10 soft_rst_2 = 1;
        #10 soft_rst_2 = 0;
        #10 parity_done = 1;
        #10 parity_done = 0;
        #10 low_pkt_valid = 1;
        #10 low_pkt_valid = 0;
        #10 din = 1;
        #10 pkt_valid = 1;
        #10 pkt_valid = 0;
        #10 fifo_full = 1;
        #10 fifo_full = 0;
        #10 fifo_empty_0 = 1;
        #10 fifo_empty_0 = 0;
        #10 fifo_empty_1 = 1;
        #10 fifo_empty_1 = 0;
        #10 fifo_empty_2 = 1;
        #10 fifo_empty_2 = 0;
    end
    
endmodule
