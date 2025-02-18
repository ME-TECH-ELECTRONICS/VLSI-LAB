interface ram_if;
    logic clk,
    logic rst,
    logic rd_en,
    logic wr_en,
    logic [3:0] wr_addr,
    logic [3:0] rd_addr,
    logic [7:0] din,
    logic [7:0] dout

    initial clk = 0;
    always #5 clk = ~clk;
endinterface