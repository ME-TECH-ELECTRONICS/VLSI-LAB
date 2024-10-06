module router (
    input clk,
    input rst,
    input [7:0] d_in,
    input pkt_valid,
    input rd_en_0,
    input rd_en_1,
    input rd_en_2,
    output vld_out_0,
    output vld_out_1,
    output vld_out_2,
    output err,
    output busy,
    output [7:0] dout_0,
    output [7:0] dout_1,
    output [7:0] dout_2,
);

    wire soft_rst_0, full_0, empty_0, soft_rst_1, full_1, empty_1, soft_rst_2, full_2, empty_2, fifo_full, detect_addr, ld_state,laf_state, full_state, lfd_state, rst_int_reg, parity_done, low_pkt_valid, write_enb_reg;
wire[2:0] wr_en;
wire[7:0] din;

    //INSTANCSTATIONS OF FIFOS
    fifo FIFO_0 (clk, rst, soft_rst_0, wr_en[0], rd_en_0, lfd_state, din, full_0, empty_0, dout_0);
    fifo FIFO_1 (clk, rst, soft_rst_1, wr_en[1], rd_en_1, lfd_state, din, full_1, empty_1, dout_1);
    fifo FIFO_2 (clk, rst, soft_rst_2, wr_en[2], rd_en_2, lfd_state, din, full_2, empty_2, dout_2);

    //INSTANCSTATIONS OF SYNCHRONIZER
    synchronizer SYNC (clk, rst, d_in[1:0], detect_addr, full_0, full_1, full_2, empty_0, empty_1, empty_2, wr_en_reg, rd_en_0, rd_en_1, rd_en_2, wr_en, fifo_full, vld_out_0, vld_out_1, vld_out_2, soft_rst_0, soft_rst_1, soft_rst_2);
    
    //INSTANCSTATIONS OF REGISTERS
    register REG (clk, rst, pkt_valid, d_in, fifo_full, detect_addr, ld_state, laf_state, full_state, lfd_state, rst_int_reg, din, err, parity_done, low_pkt_valid);

    //INSTANCSTATIONS OF FSM CONTROLLER
    fsm_controller FSM (clk, rst, pkt_valid, fifo_full, fifo_empty_0, fifo_empty_1, fifo_empty_2, soft_rst_0, soft_rst_1, soft_rst_2, parity_done, low_pkt_valid, d_in[1:0], wr_en_req, detect_addr, ld_state, laf_state, lfd_state, full_state, rst_int_req, busy);

endmodule