class packet #(parameter int WIDTH,int DEPTH);
    function void print();
        $display("WIDTH: %0d", WIDTH);
        $display("DEPTH: %0d", DEPTH);   
    endfunction
endclass
module tb;

    initial begin
        packet #(16, 8) pkt = new(); // Ensure this is at the correct scope
        pkt.print();
    end
endmodule
