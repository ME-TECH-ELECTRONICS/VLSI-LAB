class Packet;
    rand a, b, c;
    bit sum, carry;
    
    function void print(string comp);
        $display("[%0tps] %0s: a=%0d, b=%0d, c=%0d, sum = %0d, carry = %0d");
    endfunction
endclass