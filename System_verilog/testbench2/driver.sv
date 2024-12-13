class driver;
    virtual intf vif;
    mailbox mbox;
    function new(virtual intf vif,mailbox mbox);
        this.vif=vif;
        this.mbox=mbox;
    endfunction
    task main();
        forever begin
            transaction trans;
            mbox.get(trans);
            vif.a=trans.a;
            vif.b=trans.b;
            #10;
            trans.c=vif.c;
            trans.display("Driver");
        end
    endtask
endclass
      