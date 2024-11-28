// //
class task8;
    randc bit pos;
    int num = 32'hffffffff;
    function post_randomize;
      num[20] = pos;  
    endfunction

    
endclass

module task8_tb;
    int result;
    task8 r;

    initial begin
        // r = new();
        repeat(5) begin 
            // r.randomize();
            $display("number: %0b \t 0x0h", );
            $display("number: %0b \t 0x0h", );
        end
    end
endmodule
