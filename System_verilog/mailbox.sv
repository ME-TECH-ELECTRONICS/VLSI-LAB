class generator;
    packet pkt;
    mailbox mbx
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction

    task run();
        repeat(2) begin
            pkt = new();
            pkt.randomize();
            mbx.put(pkt);
            $display("Generate input  into mail box");
            #10;
        end
    endtask 
endclass

class driver;
    packet pkt;
    mailbox mbx
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction

    task run();
        repeat(2) begin
            pkt = new();
            pkt.randomize();
            mbx.get(pkt);
            $display("Addr: %0d Data: %0d", pkt.addr, pkt.data);
            #10;
        end
    endtask 
endclass

class packet;
    rand[7:0] addr, data
    function void post_randomize();
        $display("");
        $display("");
    endfunction 
endclass