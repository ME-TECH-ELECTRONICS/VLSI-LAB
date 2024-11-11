class first;
  int data;
endclass
first s1;
first s2;
module module_tb ();
initial begin
  s1 = new();
  s1.data=30;
  s2=new s1;
  $display("s2.data=%0d",s2.data);
  s2.data=20;
  $display("s1.data=%0d,s2.data=%0d",s1.data,s2.data);
end 
endmodule
