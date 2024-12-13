class monitor;
    virtual intf vif;
    mailbox mbox_1;
    function new(virtual intf vif,mailbox mbox_1);
        this.vif=vif;
        this.mbox_1=mbox_1;
    endfunction
    task main();
        forever begin
            transaction trans;
            trans=new();
            trans.a=vif.a;
            trans.b=vif.b;
            trans.c=vif.c;
            #1
            mbox_1.put(trans);
            trans.display("Monitor");
        end
    endtask
endclass