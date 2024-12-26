interface router_if();
    logic clk;           
    logic rst;           
    logic [7:0] data;    
    logic pkt_valid;    
    logic rd_en_0;       
    logic rd_en_1;       
    logic rd_en_2;       
    logic vld_out_0;    
    logic vld_out_1;    
    logic vld_out_2;    
    logic err;         
    logic busy;         
    logic [7:0] dout_0; 
    logic [7:0] dout_1; 
    logic [7:0] dout_2;

    initial clk = 0;
    always #5 clk = ~clk;

    clocking cb @(posedge clk);
        output rst;
        output data;
        output pkt_valid;
        output rd_en_0;
        output rd_en_1;
        output rd_en_2;
        input vld_out_0;
        input vld_out_1;
        input vld_out_2;
        input err;
        input busy;
        input dout_0;
        input dout_1;
        input dout_2;
    endclocking

    modport tb_mod_port(clocking cb);
endinterface

