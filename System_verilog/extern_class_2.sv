class packet;
  bit [31:0] addr;
  bit [31:0] data;

  extern virtual function void display();
endclass

function void packet::display();
    $display("ADDRESS: 0x%0h", addr);
    $display("DATA: 0x%0h", data);
endfunction
  
module extern_method;
  initial begin
    packet p;
    p = new();
    p.addr = 110;
    p.data = 240;
    p.display();
  end
endmodule