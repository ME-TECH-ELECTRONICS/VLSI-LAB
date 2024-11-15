class packet;
  rand bit[7:0] addr, data;
    function void post_randomize();
        $display("Generated Packet");
        $display("Addr: %0d Data: %0d", addr, data);
    endfunction 
endclass

class generator;
    packet pkt;
    mailbox mbx;
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction

    task run();
        repeat(2) begin
            pkt = new();
            pkt.randomize();
            mbx.put(pkt);
            $display("Placed packet into mail box");
            #10;
        end
    endtask 
endclass

class driver;
    packet pkt;
    mailbox mbx;
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction

    task run();
        repeat(2) begin
            pkt = new();
            mbx.get(pkt);
            $display("Addr: %0d Data: %0d", pkt.addr, pkt.data);
            #10;
        end
    endtask 
endclass

module tb();
    mailbox mbx;
    generator gen;
    driver drv;
    initial begin
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);
        gen.run();
        drv.run();
    end
endmodule