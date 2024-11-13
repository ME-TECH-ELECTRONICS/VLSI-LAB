class packet;
    rand bit [3:0] addr;
    rand bit [3:0] start_addr;
    rand bit [3:0] end_addr;
    constraint con1 { !(start_addr inside {[0:6]}); }
    constraint con2 { !(end_addr inside {[6:9],11,[15:20]}); }
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
Endmodule