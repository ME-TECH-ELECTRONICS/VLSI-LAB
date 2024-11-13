class packet;
    rand bit [7:0] addr;
    rand bit [7:0] start_addr;
    rand bit [7:0] end_addr;
    constraint con2 { start_addr inside {0:5, 8, 10:12}; }
    constraint con1 { !(end_addr inside {[0:20]}); }
    constraint con3 { !(addr inside {[start_addr:end_addr]}); }
endclass
module constr_inside;
    initial begin
        packet pkt;
        pkt = new();

        repeat(3) begin
            pkt.randomize();
            $display("\tstart_addr = 0x%0h,end_addr = 0x%0h",pkt.start_addr,pkt.end_addr);
            $display("\taddr = 0x%0h",pkt.addr);
            $display("------------------------------------");
        end
    end
endmodule