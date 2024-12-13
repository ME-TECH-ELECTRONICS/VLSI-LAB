class generator;
 	rand transaction trans;
 	mailbox mbox;
  	event ended;
  	int repeat_cnt;
  	
  	function new(mailbox mbox);
    	this.mbox=mbox;
  	endfunction
  	
  	task main();
    	repeat(repeat_cnt) begin
    		trans=new();
    		if(!trans.randomize()) $fatal("Gen::trans randomization failed");
      		trans.display("Generator");
      		mbox.put(trans);
      		#10;
    	end
    	->ended;
  	endtask
endclass
    
  