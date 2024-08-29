module basicGates(a,b,ny,ay,oy,nay,noy,xoy,xny);
    input a,b;
    output reg ny,ay,oy,nay,noy,xoy,xny;

    always @(*)
    begin
        ny = ~a;
        ay = a&b
        nay = ~(a&b);
        oy = a|b;
        noy = ~(a|b);
        xoy = a^b;
        xny =~(a^b);
    end
endmodule