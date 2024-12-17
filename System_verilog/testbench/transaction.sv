class Packet;
    rand bit[7:0] a, b;
    bit[7:0] sum; 
    bit carry;
    
    function void print(string comp);
        $display("[%0tps] %0s: a=%0d, b=%0d, c=%0d, sum = %0d, carry = %0d", $time, comp, a, b, c, sum, carry);
    endfunction
    
    function void copy(Packet tmp);
        a = tmp.a;
        b = tmp.b;
        sum = tmp.sum;
        carry = tmp.carry;
    endfunction
endclass