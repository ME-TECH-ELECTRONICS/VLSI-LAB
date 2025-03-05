// Code your design here
module AMBA_APB(P_clk,P_rst,P_addr,P_selx,P_enable,P_write,P_wdata,P_ready,P_slverr,P_rdata);
    //input configration 
    input P_clk;
    input P_rst;
    input [31:0]P_addr;
    
    input P_selx;
    input P_enable;
    input P_write;
    input [31:0]P_wdata;
    
    //output configration
    output reg P_ready;
    output reg  P_slverr;
    output reg [31:0]P_rdata;
    //memory decleration
    reg [31:0]mem[31:0];
    //state declaration communication
    parameter [1:0] idle=2'b00;
    parameter [1:0] setup=2'b01;
    parameter [1:0] access=2'b10;
    
    //state declaration of present and next 
    reg [1:0] present_state,next_state;
    
    always @(posedge P_clk) begin
      if(P_rst) present_state <= idle;
      else
        present_state <= next_state;
    end
    always @(*) begin
    //next_state =present_state;
    case (present_state)
      idle:begin
        if (P_selx   & !P_enable) 	
                  next_state = setup;
        P_ready=0;
      end
  
      setup:begin if (!P_enable | !P_selx) 
                          next_state = idle; 
                else begin
                          next_state =access;
                         
                  if(P_write ==1) begin
                    mem[P_addr]= P_wdata;
                    P_ready=1;
                    P_slverr=0;
                     end
                   else begin
                     P_rdata=mem[P_addr];
                     P_ready=1;
                     P_slverr=0;
                   end
                 end
      end
      access :begin
        if (!P_enable | !P_selx) begin
                          next_state = idle;
                          P_ready =0;
               end
      end
      endcase 
  end
endmodule

module tb;
    //input configration 
    reg P_clk;
    reg P_rst;
    reg [31:0]P_addr;
   
    reg P_selx;
    reg P_enable;
    reg P_write;
    reg [31:0]P_wdata;
  
     //output configration
    wire  P_ready;
    wire  P_slverr;
    wire [31:0]P_rdata;
    
    //intantiation of all port
    AMBA_APB  dut1(P_clk,P_rst,P_addr,P_selx,P_enable,P_write,P_wdata,P_ready,P_slverr,P_rdata);
    
    always #5 P_clk=~P_clk;
    
    task initialization;
      begin
        P_clk=0;
        P_rst=0;
        P_addr=0;
        P_selx=0;
        P_enable=0;
        P_write=0;
      end
    endtask
     // task reset.
    task reset;
      begin 
        P_rst=1;
        #10 P_rst=0;
      end
    endtask
    
    
    task write_stimulus;
      begin
        @(posedge P_clk);
        P_selx=1;
        P_write=1;
        P_wdata={$random}%10;
        P_addr=P_addr+1;
       
        @(posedge P_clk);
        P_enable=1;
        P_selx=1;
        @(posedge P_clk);
        P_enable=0;
        P_selx=0;
        
        @(posedge P_clk);
        $strobe ("writing data into memory data_in=%0d adress_in=%0d" , P_wdata,P_addr);
      end
    endtask
        
     task read_stimulus;
      begin
        @(posedge P_clk);
         P_write=0;
         P_selx=1;
         P_enable=0;
        //P_addr=P_addr+1;
        @(posedge P_clk); 
        P_enable=1;
        P_selx=1;
        P_addr<=P_addr+1;
        @(posedge P_clk); 
        P_enable=0;
        P_selx=0;
        
        @(posedge P_clk);
        $strobe("reading data from memory data_out=%0d   address_out=%0d",P_rdata,P_addr);
      end
    endtask
    
     task read_write;
    begin 
      repeat(2) begin 
        write_stimulus;
      end
      #1
      P_addr=0;
      repeat(3) begin 
        read_stimulus;
      end
    end
    endtask
    
      initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
      initialization;//initialize input values
      reset;// generate signal
      read_write;
       #80; $finish;
    end 
endmodule