class Packet;
    rand bit[7:0] header;
    rand bit[7:0] data;
    rand bit pkt_valid;
    rand bit rd_en_0;
    rand bit rd_en_1;
    rand bit rd_en_2;
    bit vld_out_0;   
    bit vld_out_1;   
    bit vld_out_2;   
    bit err;         
    bit busy;        
    bit [7:0] dout_0;
    bit [7:0] dout_1;
    bit [7:0] dout_2;
    logic[7:0] parity;

    constraint con1 { header[1:0] != 2'b11; }

    function void print(string comp);
        $display("[%0tps] %0s: Header = %0h, Data = 0x%0h, pkk_valid = %0b, rd_en_0 = %0b, rd_en_1 = %0b, rd_en_2 = %0b, vld_out_0 = %0b, vld_out_1 = %0b, vld_out_2 = %0b, err = %0b, busy = %0b, dout_0 = 0x%0h, dout_1 = 0x%0h, dout_2 = 0x%0h, parity = 0x%0h", $time, comp, header, data, pkt_valid, rd_en_0, rd_en_1, rd_en_2, vld_out_0, vld_out_1, vld_out_2, err, busy, dout_0, dout_1, dout_2, parity);
    endfunction
    
  function void copy(Packet tmp);
        data = tmp.data;
        pkt_valid = tmp.pkt_valid;
        rd_en_0 = tmp.rd_en_0;
        rd_en_1 = tmp.rd_en_1;
        rd_en_2 = tmp.rd_en_2;
        vld_out_0 = tmp.vld_out_0;
        vld_out_1 = tmp.vld_out_1;
        vld_out_2 = tmp.vld_out_2;
        err = tmp.err;
        busy = tmp.busy;
        dout_0 = tmp.dout_0;
        dout_1 = tmp.dout_1;
        dout_2 = tmp.dout_2;
        parity = tmp.parity;
    endfunction

endclass


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
endinterface

interface router_clk();
    logic clk;
    initial clk <= 0;
    always #5 clk <= ~clk;
endinterface


class Driver;
    local bit[7:0] header;
    mailbox mbx;
    event drv_done;
    event headerByte;
    virtual router_if vif;
    virtual router_clk clk_vif;

  function new(mailbox mbx, event drv_done, virtual router_if vif, virtual router_clk clk_vif, event headerByte);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.headerByte = headerByte;
        this.vif = vif;
        this.clk_vif = clk_vif;
    endfunction

    task run();
        $display("[%0tps] Driver: Starting...", $time);
        forever begin
            Packet pld = new();
          	vif.rst = 1;
            @(!vif.busy)
            @(posedge clk_vif.clk);
            
            mbx.get(header);
            $display("[%0tps] Driver: Recevied header byte.", $time);
            pld.parity = pld.parity ^ header; 
            vif.pkt_valid = 1;
            vif.data = header;
            for (int i = 0; i <= header[7:2]; i++) begin
                mbx.get(pld);
                pld.print("Driver");
                vif.data = pld.data;
                pld.parity = pld.parity ^ pld.data;
                ->drv_done;
                @(posedge clk_vif.clk);
            end
            vif.pkt_valid = 0;
            vif.data = pld.parity;
        end
        
    endtask
endclass 

 class Generator;
    mailbox mbx;
    event drv_done;
    event headerByte;

    function new(mailbox mbx, event drv_done, event headerByte);
        this.mbx = mbx;
        this.drv_done = drv_done;
        this.headerByte = headerByte;
    endfunction

    task run();
        Packet pld = new();
        if(!pld.randomize()) $error("Packet randomization failed");
        pld.print("generator");
        mbx.put(pld.header);
      #3;
        ->headerByte;
        for (int i = 0; i <= pld.header[7:2]; i++) begin
            if(!pld.randomize()) $error("Payload randomization failed");
            pld.print("generator");
            mbx.put(pld);
            @(drv_done);
        end
    endtask


 endclass 

class Environment;
    Generator gen;
    Driver drv;
    // Monitor mon;
    // Scoreboard sbd;
    
    mailbox drv_mbx;
    // mailbox sbd_mbx;
    event drv_done;
    event headerByte;
    virtual router_if router_vif;
    virtual router_clk router_clk_vif;
    
  function new(virtual router_if router_vif, virtual router_clk router_clk_vif);
        drv_mbx = new();
        // sbd_mbx = new();
        gen = new(drv_mbx, drv_done, headerByte);
        drv = new(drv_mbx, drv_done, router_vif, router_clk_vif, headerByte);
        // mon = new(adder_vif, sbd_mbx);
        // sbd = new(sbd_mbx);
    endfunction
    
    task run();
        fork
            gen.run();
            drv.run();
            // mon.run();
            // sbd.run();
        join_any
    endtask
endclass

module testbench_runner();
  	router_if intf();
  	router_clk clk_if();
  	Environment env = new(intf, clk_if);

  router dut(clk_if.clk, intf.rst, intf.data, intf.pkt_valid, intf.rd_en_0, intf.rd_en_1, intf.rd_en_2, intf.vld_out_0, intf.vld_out_1, intf.vld_out_2, intf.err, intf.busy);
  	initial begin
   		env.run();
        #50 $finish;
  	end
  	initial begin
        $dumpfile("out.vcd");
        $dumpvars(1);
    end
endmodule