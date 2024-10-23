module printMsg ();
   string msg = "Hello world!";
    initial begin
        $display("Msg: %s", msg);
    end
endmodule