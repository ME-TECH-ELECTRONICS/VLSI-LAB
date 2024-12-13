class scoreboard;
    mailbox mbox_1;
    function new(mailbox mbox_1);
        this.mbox_1=mbox_1;
    endfunction
    
    task main();
        transaction trans;
        forever begin
            mbox_1.get(trans);
            if(trans.a&trans.b==trans.c)
                $display("Result is expected");
            else
                $error("wrong result");
            trans.display("Scoreboard");
        end
    endtask
endclass