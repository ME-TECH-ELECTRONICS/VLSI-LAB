//class with extern task
class packet;
  bit [31:0] addr;
  bit [31:0] data;

  extern virtual task display();
endclass

task packet::display();
  $display("ADDRESS: 0x%0h", addr);
  $display("DATA: 0x%0h", data);
endtask
  
module extern_class_tb;
  initial begin
    packet p;
    p = new();
    p.addr = 120;
    p.data = 200;
    p.display();
  end
endmodule