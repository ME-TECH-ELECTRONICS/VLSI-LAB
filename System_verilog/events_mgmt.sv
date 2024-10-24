module events_mgmt ();
    event ev1;
    initial begin
        fork
            begin
                 #60;  
                 $display($time,"\t Triggring Event");
                 -> ev1;
            end
            begin
               $display($time,"\t Waitingg for event trigger");
               #20;
              @(ev1);
               $display($time,"\t Event Triggered");
            end
        join
    end
    initial begin
        #100;
      $display($time,"\t Ending Simulation");

    end
endmodule