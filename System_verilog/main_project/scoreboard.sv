class Scoreboard;
    bit[7:0] header = 0;
    mailbox #(Packet) mbx_in;
    mailbox #(Packet) mbx_out;
    virtual router_if vif;
    bit[7:0] in_stream[$], out_stream[$];
    logic TX_done = 0;
    logic RX_done = 0;
    
    function new(mailbox #(Packet) mbx_in, mailbox #(Packet) mbx_out);
        this.mbx_in = mbx_in;
        this.mbx_out = mbx_out;
    endfunction
    
    task in_run();
        forever begin
            Packet pkt;
            if(mbx_in.num() > 0) begin
                mbx_in.get(pkt);
              checkPacket(pkt, this.header);
            end else begin
                #10; 
            end
        end
    endtask
    
    task out_run();
        int count = 1;
        //int c = 0;
        forever begin
            Packet pkt;
            if (mbx_out.num() > 0) begin
                mbx_out.get(pkt);
              $display("Header: ",header[7:2] + 1);
                checkPacket_1(pkt);
              checkall();
              if (!(count >= header[7:2] + 1))
                   count++;
                
            end else begin
                #10; // Prevent busy-waiting
            end
        end
    endtask
    
  task checkPacket(Packet item,ref bit[7:0] header );
        bit[8:0] cnt; 
        if(item.pkt_valid && item.rst) begin
          if(item.pkt_type == HEADER) begin
                header = item.data;
                cnt = header[7:2] + 2;
                in_stream.push_back(header);
             
            end
            if(item.pkt_type == PAYLOAD || item.pkt_type == PARITY) begin
                in_stream.push_back(item.data);
                $display("payload recived");
            end
        end
    endtask
    
    task checkall();
        $display("Header: %0b | %0h", header, header);
        if((in_stream.size() == header[7:2] + 1) && (out_stream.size() == header[7:2] + 1))
          $display("Scoreboard is complete", header[7:2] + 1);
        else
          $display("Scoreboard is not complete %0d/%0d", in_stream.size(), out_stream.size(), header[7:2] + 1);
    endtask

    task checkPacket_1(Packet item);
        if(item.rd_en_0 && item.dout_0 != 0)
            out_stream.push_back(item.dout_0);
        else if(item.rd_en_1 && item.dout_1 != 0)
            out_stream.push_back(item.dout_1);
        else if(item.rd_en_2 && item.dout_2 != 0)
            out_stream.push_back(item.dout_2);
      $display(out_stream);
    endtask
endclass