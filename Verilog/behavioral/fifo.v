module fifo_16x8(
input wire clk,        
    input wire rst,      
    input wire wr_en,      
    input wire rd_en,      
    input wire [7:0] din,  
    output reg [7:0] dout, 
    output wire full,      
    output wire empty      
);

    reg [7:0] fifo_mem [15:0]; 
    reg [3:0] wr_ptr = 0;      
    reg [3:0] rd_ptr = 0;      
    reg [4:0] count = 0;       

    // Write Operation
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            wr_ptr <= 0;
            dout <= 8'b0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr] <= din;    
            wr_ptr <= wr_ptr + 1;       
        end
    end

    // Read Operation
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            rd_ptr <= 0;
            dout <= 8'b0;
        end else if (rd_en && !empty) begin
            dout <= fifo_mem[rd_ptr];   
            rd_ptr <= rd_ptr + 1;       
        end
    end

    assign full = (count == 15);
    assign empty = (count == 0);

    // Count Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 0;
        end else if (wr_en && !full && rd_en && !empty) begin
            count <= count;   // When both read and write occur simultaneously
        end else if (wr_en && !full) begin
            count <= count + 1;  // Increment count on write
        end else if (rd_en && !empty) begin
            count <= count - 1;  // Decrement count on read
        end
    end
endmodule

module fifo_16x8_tb();
    reg clk=0,rst;
    reg wr_en,rd_en;
    reg [7:0] din;
    wire [7:0] dout;
    wire full,empty;

    fifo_16x8 dut(clk,rst,wr_en,rd_en,din,dout,full,empty);
    always #5 clk = ~clk;
    integer i,j;
    initial begin
        // $dumpfile("out.vcd");
        // $dumpvars(1);
        rst = 0; #10;
        rst = 1; 
        wr_en = 0; rd_en = 0; din = 8'b0;
        #10;
        wr_en =1;
        for (i = 0; i<15; i=i+1) begin
            din = $urandom_range(0, 255);
		  #10;
        end
        rd_en = 1;
        for (j = 0; j<15; j=j+1) begin
            $display("D[%0d]: %0h", j, dout);
		  #10;
        end
        $finish;
    end
endmodule
