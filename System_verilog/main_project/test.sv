//=====================================================//
//========================PACKET=======================//
//=====================================================//
typedef enum {IDLE,RESET,STIMULUS,CSR_READ,CSR_WRITE} pkt_type_t;

class packet;

  rand bit [7:0] sa; //declare required ports
  rand bit [7:0] da;
  bit [31:0] len;
  bit [31:0] crc;
  rand bit [7:0] payload[];
  bit [7:0] inp_stream[$]; //for packing/unpacking the packet
  bit [7:0] outp_stream[$];
  pkt_type_t kind; //to select kind of txn packet
  bit [7:0] reset_cycles; 
  bit [7:0] addr; //for config read/write
  logic [31:0] data;
  //constraints on design ports
  constraint valid_sa {
    sa inside {[1:4]};}
  constraint valid_da {
    da inside {[1:4]}; }
  constraint valid_payload {
  	payload.size() inside {[1:199]};
    foreach(payload[i])
  		payload[i] inside {[1:255]};
  	}
  function void post_randomize();
      len = payload.size()+1+1+4+4;
      crc=payload.sum();
      this.pack(inp_stream);
  endfunction
  function void pack(ref bit [7:0] q_inp[$]);
      q_inp = { << 8 {this.payload,this.crc,this.len, this.da, this.sa}};
  endfunction
  function void unpack (ref bit [7:0] q_inp[$]);
      { << 8 {this.payload,this.crc,this.len, this.da, this.sa}} = q_inp;
  endfunction
  function void copy( packet rhs);
      if(rhs==null) begin
      $display("[ERROR] null handle passed to copy method");
      $finish;
      end
      this.sa = rhs.sa;
      this.da = rhs.da;
      this.len = rhs.len;
      this.crc = rhs.crc;
      this.payload = rhs.payload;
      this.inp_stream = rhs.inp_stream;
  endfunction
  function bit compare (input packet dut_pkt);
      bit status =1;
      if (this.inp_stream.size() != dut_pkt.outp_stream.size()) begin
          $display("[COMPARE_ERROR] SIZE MISMATCHED expected size=%d, recieved size=%d",this.inp_stream.size(),dut_pkt.outp_stream.size());
          return 0;
      end
      foreach(this.inp_stream[i]) begin
          status = status && (this.inp_stream[i] == dut_pkt.outp_stream[i]);
          return status;
      end
  endfunction
  function void print();
      $display ("[PACKET PRINT] sa= %d, da= %d, len= %d, crc= %d",this.sa,this.da,this.len,this.crc);
      $display("[PAYLOAD]");
      foreach(payload[i])
  	    $write("payload[%d]= %h",i, this.payload[i]);
          $display("\n");
  endfunction
endclass


//=====================================================//
//========================GENERATOR====================//
//=====================================================//
class generator;

  packet ref_pkt;
  mailbox #(packet) mbx;
  bit [15:0] pkt_count;

  function new(input mailbox #(packet) mbx_org, bit [31:0] pkt_count_arg);
    this.mbx = mbx_org;
    this.pkt_count = pkt_count_arg;
    ref_pkt = new();
  endfunction

  task run ();
    bit [31:0] pkt_id;
    packet pkt;
    pkt=new();
    pkt.kind = RESET;
    pkt.reset_cycles=2;
    $display("[GENERATOR] sending %s packet %d to driver at time %t",pkt.kind.name(),pkt_id,$time);
    mbx.put(pkt);

    pkt=new();
    pkt.kind=CSR_WRITE;
    pkt.addr='h20; //csr_sa_enable addr 20
    pkt.data=31'hf;
    $display("[GENERATOR] sending %s packet %d to driver at time %t",pkt.kind.name(),pkt_id,$time);
    mbx.put(pkt);

    pkt=new();
    pkt.kind=CSR_WRITE;
    pkt.addr='h24; //csr_da_enable addr 24
    pkt.data=31'hf;
    $display("[GENERATOR] sending %s packet %d to driver at time %t",pkt.kind.name(),pkt_id,$time);
    mbx.put(pkt);

    repeat(pkt_count) begin
    pkt_id++;
    assert(ref_pkt.randomize());
    pkt=new;
    pkt.copy(ref_pkt);
    pkt.kind=STIMULUS;
    $display("[GENERATOR] sending %s packet %d to driver at time %t",pkt.kind.name(),pkt_id,$time);
    mbx.put(pkt);
    end

    pkt=new();
    pkt.kind=CSR_READ;
    pkt.addr='h36; // csr_total_inp_pkt_count
    $display("[GENERATOR] sending %s packet %d to driver at time %t",pkt.kind.name(),pkt_id,$time);
    mbx.put(pkt);

    pkt=new();
    pkt.kind=CSR_READ;
    pkt.addr='h40; // csr_total_outp_pkt_count
    $display("[GENERATOR] sending %s packet %d to driver at time %t",pkt.kind.name(),pkt_id,$time);
    mbx.put(pkt);
  endtask
endclass;

//=====================================================//
//========================DRIVER=======================//
//=====================================================//
class driver;

  packet pkt;
  mailbox #(packet) mbx;
  bit [15:0] no_of_pkts_received;
  bit [31:0] csr_rdata;
  virtual router_if.tb_mod_port vif;

  function new(input mailbox #(packet) mbx_arg, input virtual router_if.tb_mod_port vif_arg);
  this.mbx= mbx_arg;
  this.vif=vif_arg;
  endfunction

  extern task run();
  extern task drive(packet pkt);
  extern task drive_reset(packet pkt);
  extern task configure_dut_csr(packet pkt);
  extern task drive_stimulus(packet pkt);
  extern task read_dut_csr(packet pkt);

endclass

task driver::drive_reset(packet pkt);
  $display("[Driver] Generating reset packet to dut at time %0t",$time);
  vif.reset <=1'b1;
  repeat(pkt.reset_cycles) @(vif.cb);
  vif.reset <=1'b0;
  $display("[Driver] Reset to dut completed at time %0t",$time);
endtask

task driver::configure_dut_csr(packet pkt);
  $display("[Driver] configure packet started to dut at time %0t",$time);
  @(vif.cb);
  vif.cb.wr <= 1'b1;
  vif.cb.addr <= pkt.addr;
  vif.cb.wdata <= pkt.data;
  @(vif.cb);
  vif.cb.wr <= 1'b0;
  $display("[Driver] configure packet ended to dut at time %0t",$time);
endtask

task driver::drive_stimulus(packet pkt);
  wait(vif.cb.busy==0);
  @(vif.cb);
  $display("[Driver] sending stimulus packet to dut at time %0t",$time);
  //$display("[DUMMY] valid = %d",vif.cb.inp_valid);
  vif.cb.inp_valid <= 1'b1;
   // $display("[DUMMY] valid = %d",vif.cb.inp_valid);
  foreach(pkt.inp_stream[i]) begin
    vif.cb.dut_inp <= pkt.inp_stream[i];
    @(vif.cb);
  end
  vif.cb.inp_valid <= 1'b0;
  vif.cb.dut_inp <= 'z;
  repeat(5) @(vif.cb)
  $display("[Driver] sending done stimulus packet to dut at time %0t",$time);
endtask

task driver::read_dut_csr(packet pkt);
  $display("[Driver] Reading dut status registers started at time %0t",$time);
  @(vif.cb);
  vif.cb.rd <= 1'b1;
  vif.cb.addr <= pkt.addr;
  repeat(2) @(vif.cb)
  csr_rdata <= vif.cb.rdata;
  vif.cb.rd <= 1'b0;
  $display("[Driver] Reading done dut status registers at time %0t",$time);
endtask

task driver::drive(packet pkt);
  case(pkt.kind)
    RESET	:	drive_reset(pkt);
    STIMULUS :	drive_stimulus(pkt);
    CSR_WRITE :	configure_dut_csr(pkt);
    CSR_READ :	read_dut_csr(pkt);
    default	:	$display("[Driver] ERROR unknown packet received");
  endcase
endtask

task driver::run();
  $display("[Driver] run started at time %0t",$time);
  while(1) begin
    mbx.get(pkt);
    no_of_pkts_received++;
    $display("[Driver] received %0s packet %0d from generator at time %0t", pkt.kind.name(),no_of_pkts_received,$time);
    drive(pkt);
    $display("[Driver] done with %0s packet %0d from generator at time %0t", pkt.kind.name(),no_of_pkts_received,$time);
  end
endtask



//=====================================================//
//========================IMONITOR=====================//
//=====================================================//
class imonitor;
  packet pkt;
  mailbox #(packet) mbx;
  virtual router_if.tb_mon vif;
  bit [15:0] no_of_pkts_received;

  function new(input mailbox #(packet) mbx_arg, input virtual router_if.tb_mon vif_arg);
    this.mbx = mbx_arg;
    this.vif = vif_arg;
  endfunction

  task run();
    bit [7:0] inp_q[$];
    $display("[iMonitor] monitor strated at time %0t",$time);
    forever begin
      @(posedge vif.mcb.inp_valid);
      no_of_pkts_received++;
      $display("[iMonitor] started collecting packet %0d at time %0t",no_of_pkts_received,$time);

      while(1) begin
        if(vif.mcb.inp_valid==0) begin
          pkt = new;
          pkt.unpack(inp_q);
          pkt.inp_stream=inp_q;
          mbx.put(pkt);
          $display("[iMonitor] sent packet %0d to scoreboard at time %0t",no_of_pkts_received,$time);
          inp_q.delete();
          break;
        end
        inp_q.push_back(vif.mcb.dut_inp);
        @(vif.mcb);
      end
    end
  endtask

  function void report();
    $display("[iMonitor] Report: Total packets received %0d",no_of_pkts_received);
  endfunction

endclass


//=====================================================//
//========================OMONITOR=====================//
//=====================================================//
class omonitor;
  packet pkt;
  mailbox #(packet) mbx;
  virtual router_if.tb_mon vif;
  bit [15:0] no_of_pkts_received;

  function new(input mailbox #(packet) mbx_arg, input virtual router_if.tb_mon vif_arg);
    this.mbx = mbx_arg;
    this.vif = vif_arg;
  endfunction


  task run();
    bit [7:0] outp_q[$];
    $display("[oMonitor] monitor strated at time %0t",$time);

    forever begin
      @(posedge vif.mcb.outp_valid);
      no_of_pkts_received++;
      $display("[oMonitor] started collecting packet %0d at time %0t",no_of_pkts_received,$time);

      while(1) begin
        if(vif.mcb.outp_valid==0) begin
          pkt = new;
          pkt.unpack(outp_q);
          pkt.outp_stream=outp_q;
          mbx.put(pkt);
          $display("[oMonitor] sent packet %0d to scoreboard at time %0t",no_of_pkts_received,$time);
          outp_q.delete();
          break;
        end
        outp_q.push_back(vif.mcb.dut_outp);
        @(vif.mcb);
      end
    end
  endtask

  function void report();
    $display("[oMonitor] Report:Total packets received %0d",no_of_pkts_received);
  endfunction

endclass

//=====================================================//
//========================SCOREBOARD===================//
//=====================================================//
class scoreboard;
  packet ref_pkt;
  packet got_pkt;
  mailbox #(packet) mbx_in, mbx_out;
  bit [15:0] total_pkts_received;
  bit [31:0] m_matched;
  bit [31:0] m_mismatched;

  function new(input mailbox #(packet) mbx_in_arg, mbx_out_arg);
  this.mbx_in=mbx_in_arg;
  this.mbx_out=mbx_out_arg;
  endfunction

  task run();
    $display("[scoreboard] run started at time %0t",$time);

    while(1) begin
      mbx_in.get(ref_pkt);
      mbx_out.get(got_pkt);
      total_pkts_received++;
      $display("[scoreboard] packet %0d received",total_pkts_received);
      if(ref_pkt.compare(got_pkt)) begin
        m_matched++;
        $display("[scoreboard] packet %0d matched",total_pkts_received);
      end
      else begin
        m_mismatched++;
        $display("[scoreboard] ERROR packet %0d mismatched at time %0t",total_pkts_received,$time);
        $display("[scoreboard] --expected DUT packet-- ");
        ref_pkt.print();
        $display("[scoreboard] --received DUT packet-- ");
        got_pkt.print();
      end
    end
    $display("[scoreboard] run ended at time %0t",$time);
  endtask

  function void report();
    $display("[scoreboard] Report: total packets received %0d",total_pkts_received);
    $display("[scoreboard] Report: matched %0d mismatched %0d",m_matched,m_mismatched);
  endfunction

endclass

//=====================================================//
//=======================ENVIRONMENT===================//
//=====================================================//
`include "packet.sv"
`include "generator.sv"
`include "driver.sv"
`include "imonitor.sv"
`include "omonitor.sv"
`include "scoreboard.sv"

class environment;

  generator gen;
  driver drvr;
  imonitor mon_in;
  omonitor mon_out;
  scoreboard scb;

  bit [31:0] no_of_pkts;
  bit env_disable_report;
  bit env_disable_EOT;

  mailbox #(packet) mbx_gen_drvr;
  mailbox #(packet) mbx_imon_scb;
  mailbox #(packet) mbx_omon_scb;

  virtual router_if.tb_mod_port vif;
  virtual router_if.tb_mon	vif_mon_in;
  virtual router_if.tb_mon 	vif_mon_out;

  function new(input virtual router_if.tb_mod_port vif_in, virtual router_if.tb_mon vif_mon_in,virtual router_if.tb_mon vif_mon_out,input bit [31:0] no_of_pkts);
    this.vif = vif_in;
    this.vif_mon_in = vif_mon_in;
    this.vif_mon_out = vif_mon_out;
    this.no_of_pkts = no_of_pkts;
  endfunction

  function void build();
    $display("[environment] build started at time %0t",$time);
    mbx_gen_drvr = new(1);
    mbx_imon_scb = new();
    mbx_omon_scb = new();

    gen = new(mbx_gen_drvr, no_of_pkts);
    drvr = new(mbx_gen_drvr,vif);
    mon_in = new(mbx_imon_scb,vif_mon_in);
    mon_out = new(mbx_omon_scb,vif_mon_out);
    scb = new(mbx_imon_scb,mbx_omon_scb);
    $display("[environment] build ended at time %0t",$time);
  endfunction

  task run();

    $display("[environment] run started at time %0t",$time);
    fork
    gen.run();
    drvr.run();
    mon_in.run();
    mon_out.run();
    scb.run();
    join_any

      if(!(env_disable_EOT))
        wait(scb.total_pkts_received==no_of_pkts);
      if(!(env_disable_report)) report();
        $display("[environment] run ended at time %0t",$time);
  endtask

  function void report();
    $display("[environment] ******** Report started********");
    mon_in.report();
    mon_out.report();
    scb.report();
    if((scb.m_mismatched ==0) && (scb.total_pkts_received == no_of_pkts))
      $display("[environment] ******** TEST PASSED *******");
    else
      $display("[environment] ******** TEST FAILED *******");
    $display("[envirnoment] matched = %0d mismatched = %0d",scb.m_matched,scb.m_mismatched);
  endfunction
endclass

//=====================================================//
//==========================TEST=======================//
//=====================================================//
`include "environment.sv"

class base_test;

  environment env;

  bit [31:0] no_of_pkts;

  virtual router_if.tb_mod_port vif;
  virtual router_if.tb_mon 	vif_mon_in;
  virtual router_if.tb_mon 	vif_mon_out;

  function new(input virtual router_if.tb_mod_port vif_in, virtual router_if.tb_mon vif_mon_in,virtual router_if.tb_mon vif_mon_out);
    this.vif = vif_in;
    this.vif_mon_in = vif_mon_in;
    this.vif_mon_out = vif_mon_out;
  endfunction

  function void build();
    $display("[test] build started at time %0t",$time);
    env = new(vif,vif_mon_in,vif_mon_out,no_of_pkts);
    env.build();
    $display("[test] build ended at time %0t",$time);
  endfunction

  task run();
    $display("[test] run strated at time %0t",$time);
    no_of_pkts = 10;
    build();
    env.run();
    $display("[test] run ended at time %0t",$time);
  endtask

endclass


//=====================================================//
//=======================TESTBENCH=====================//
//=====================================================//
//typedef enum {IDLE,RESET,STIMULUS,CSR_READ,CSR_WRITE} pkt_type_t;

interface router_if(input clk);
  logic reset;
  logic [7:0] dut_inp;
  logic inp_valid;
  logic [7:0]dut_outp;
  logic outp_valid;
  logic busy;
  logic error;
  //CSR related signals
  logic wr,rd;
  logic [7:0]  addr;
  logic [31:0] wdata;
  logic [31:0] rdata;

  clocking cb@(posedge clk);
    output dut_inp;//Direction are w.r.t TB
    output inp_valid;
    input dut_outp;
    input outp_valid;
    input busy;
    input error;
  	output wr,rd;
  	output addr;
  	output wdata;
  	input rdata;
  endclocking

  clocking mcb@(posedge clk);
    input dut_inp;
    input inp_valid;
    input dut_outp;
    input outp_valid;
  	input busy;
    input error;
  endclocking


  modport tb_mod_port (clocking cb , output reset);

  modport tb_mon (clocking mcb);

endinterface

`include "test.sv"
program testbench(router_if vif);

  base_test test;

  initial begin
    $display("[Program block] run started at time %0t",$time);
    test = new(vif.tb_mod_port,vif.tb_mon,vif.tb_mon);
    test.run();
    $display("[Program block] run finished at time %0t",$time);
  end

endprogram


module top;

//Section1: Variables for Port Connections Of DUT and TB.
logic clk;

//Section2: Clock initiliazation and Generation

initial clk=0;
always #5 clk = !clk;


//Section 8: Instantiate interface

router_if router_if_inst(clk);

//Section3:  DUT instantiation

router_dut dut_inst(.clk(clk),

  .reset(router_if_inst.reset),

  .dut_inp(router_if_inst.dut_inp),

  .inp_valid(router_if_inst.inp_valid),

  .dut_outp(router_if_inst.dut_outp),

  .outp_valid(router_if_inst.outp_valid),

  .busy(router_if_inst.busy),

  .error(router_if_inst.error),

  .wr(router_if_inst.wr),

  .rd(router_if_inst.rd),

  .addr(router_if_inst.addr),

  .wdata(router_if_inst.wdata),

  .rdata(router_if_inst.rdata)
);

//Section4:  Program Block (TB) instantiation

testbench  tb_inst(.vif(router_if_inst));

//Section 6: Dumping Waveform

initial begin

  $dumpfile("dump.vcd");

  $dumpvars(0,top.dut_inst); 

end

endmodule



//=====================================================//
//==========================DUT========================//
//=====================================================//
//sa ,da,len,crc,payload
module router_dut (clk,reset,dut_inp,inp_valid,dut_outp,outp_valid,busy,error,wr,rd,addr,wdata,rdata);
  input clk,reset;
  input [7:0] dut_inp;
  input inp_valid;
  input wr,rd;
  input [7:0] addr;
  input [31:0] wdata;
  output [31:0] rdata;
  output [7:0] dut_outp;
  output outp_valid;
  output busy;
  output error;
  reg [7:0] dut_outp;
  reg [31:0] rdata;
  reg outp_valid;
  reg busy,error;
logic [7:0] inp_pkt[$];
bit done; 
bit [31:0] len_recv; 
bit [3:0] csr_sa_enable;//addr='h20;
bit [3:0] csr_da_enable;//addr='h24;
bit [31:0] csr_crc_dropped_count;//addr='h28
bit [31:0] csr_pkt_dropped_count; //addr='h32;
bit [31:0] csr_total_inp_pkt_count;//addr='h36;
bit [31:0] csr_total_outp_pkt_count;//addr='h40;

always @(posedge clk or posedge reset) begin 

if(reset) begin
csr_crc_dropped_count<=0;
csr_pkt_dropped_count<=0;
csr_total_inp_pkt_count<=0;
csr_total_outp_pkt_count<=0;
rdata<=0;
 //$display("DUT reset done at %t",$time);
end
   
else if (wr===1'b1) begin
case (addr) 
 'h20 : csr_sa_enable <= wdata;
 'h24 : csr_da_enable <= wdata;
 default: begin 
			$display("[DUT_ERROR] invalid csr write address(%0h) received at time=%0t",addr,$time);
		end
endcase
end
else if (rd===1'b1) begin
case (addr) 
 'h28 : rdata <= csr_crc_dropped_count;
 'h32 : rdata <= csr_pkt_dropped_count;
 'h36 : rdata <= csr_total_inp_pkt_count;
 'h40 : rdata <= csr_total_outp_pkt_count;
 default: begin 
			$display("[DUT_ERROR] invalid csr read address(%0h) received at time=%0t",addr,$time);
		  end
endcase
end
end//end_of_always


//sa0 da1 len2 len3 len4 len5
always@(posedge clk or posedge reset) begin 
if(reset) begin
busy<=0;
inp_pkt.delete();
done<=0;
len_recv=0;
error<=0; 
end
else begin
while(inp_valid && csr_sa_enable) begin
 inp_pkt.push_back(dut_inp);
 if($test$plusargs("dut_debug_input"))
    $display("[DUT Input] dut_inp=%0d at time=%0t",dut_inp,$time);
 @(posedge clk);
 if(inp_pkt.size() == 6) len_recv={inp_pkt[5],inp_pkt[4],inp_pkt[3],inp_pkt[2]};
 if (inp_pkt.size() == len_recv) begin
      csr_total_inp_pkt_count++;
	  if($test$plusargs("dut_debug") )
      $display("[DUT Input] Total Packet %0d collected size=%0d at time=%0t",csr_total_inp_pkt_count,inp_pkt.size(),$time);
	  
			if(is_packet_not_ok(inp_pkt)) begin
			inp_pkt.delete();
			break;//drop the packet as size is not ok
			end
	  		if(is_da_not_ok(inp_pkt[1])) begin
			inp_pkt.delete();
			break;//drop the packet as da is invalid
			end

		   if(calc_crc(inp_pkt)) begin
			  done<=1;
			  busy<=1;
			  len_recv<=0;
			  break; 
		   end//end_of_crc_if
   else begin
    csr_crc_dropped_count++;
    if($test$plusargs("dut_debug_crc")) begin
    $display("[DUT CRC] Packet %0d Dropped in DUT due to CRC Mismatch at time=%0t",csr_total_inp_pkt_count,$time);
    end
    inp_pkt.delete();
    done<=0;
    busy<=0;
    len_recv<=0;
    break;
   end
  end//end_of_if
end//end_of_while
end//end_of_main_if_else
end//end_of_always

always @(posedge clk) begin
while (done==1 && error==0) begin
@(posedge clk);
outp_valid <=1;
dut_outp <= inp_pkt.pop_front();
 if($test$plusargs("dut_debug_output"))
    $strobe("[DUT Output] dut_outp=%0d at time=%0t",dut_outp,$time);
if(inp_pkt.size() ==0) begin
      csr_total_outp_pkt_count++;
   if($test$plusargs("dut_debug") )
      $display("[DUT Output] Total Packet %0d Driving completed at time=%0t \n",csr_total_outp_pkt_count,$time);
  done<=0;
  len_recv<=0;
  busy<=0;
  @(posedge clk);
  dut_outp <= 'z;
  outp_valid <= 1'b0;
  //break;
end//end_of_if;  
end//end_of_while
end

always@(inp_valid or dut_inp) begin
if(!$isunknown(dut_inp) && busy && inp_valid) begin
    if($test$plusargs("dut_debug"))begin
     $display("[DUT Protocol ERROR] *************************************");
     $display("[DUT Protocol] Protocol violation detected at time=%0t",$time);
     $display("[DUT Protocol] inp_valid or dut_inp changed while router is busy at time=%0t",$time);
     $display("[DUT Protocol ERROR] *************************************");
    end
     error =1;
end
else error=0;
end

//sa0 da1 len2 
//len3 len4 len5
//crc6 crc7 crc8 crc9
//payload10->to->end ofpacket
function automatic bit calc_crc(const ref logic [7:0] pkt[$]);
bit [31:0] crc,new_crc;
bit [7:0] payload[$];
crc={pkt[9],pkt[8],pkt[7],pkt[6]};
for(int i=10;i < pkt.size(); i++) begin
    payload.push_back(pkt[i]);
end
new_crc=payload.sum();
payload.delete();
    if($test$plusargs("dut_debug_crc"))
       	$display("[DUT CRC] Received crc=%0d caluclated crc=%0d at time=%0t",crc,new_crc,$time);
return (crc == new_crc);
endfunction

function automatic bit is_packet_not_ok(const ref logic [7:0] pkt[$]);
if(pkt.size() < 12 || pkt.size() > 2001) begin
csr_pkt_dropped_count++; //Drop the packet as its not satisfying minimum or maximux size of packet
 if($test$plusargs("dut_debug")) begin
	$display("[DUT_ERROR] Packet %0d Dropped in DUT due to size mismatch at time=%0t",csr_total_inp_pkt_count,$time);
	$display("[DUT_ERROR] Received packet size=%0d , Allowed range 12Bytes ->to-> 2000 Bytes ",pkt.size());
 end

done=0;
busy<=0;
len_recv<=0;
return 1;
end else return 0;
endfunction

function automatic bit is_da_not_ok(logic [7:0] da);
if(! (da inside {[1:4]})) begin
csr_pkt_dropped_count++; //Drop the packet as da port does not exists
 if($test$plusargs("dut_debug")) begin
	$display("[DUT_ERROR] Packet %0d Dropped in DUT due to invalid da(%0d) port received at time=%0t",csr_total_inp_pkt_count,da,$time);
	$display("[DUT_ERROR] Received packet da=%0d , Allowed da values {1,2,3,4} ",da);
 end

done=0;
busy<=0;
len_recv<=0;
return 1;
end 
else if (csr_da_enable)
	       return 0;
else begin
csr_pkt_dropped_count++; //Drop the packet as da port is not enabled
if($test$plusargs("dut_debug")) begin
	$display("[DUT_ERROR] Packet Dropped in DUT due to da(%0d) port is not enabled at time=%0t",csr_total_inp_pkt_count,da,$time);
end
done=0;
busy<=0;
len_recv<=0;
return 1;
end
endfunction

endmodule