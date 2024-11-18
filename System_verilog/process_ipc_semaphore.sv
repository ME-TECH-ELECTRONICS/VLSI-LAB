module process_ipc_semaphore ();
    semaphore sem1; // = new(2);
    semaphore sem2; // = new(4);

    task process(string name);
        $display("[%0t]: Process %0s trying to access semaphore key.", $time, name);
        sem1.get(1);
        $display("[%0t]: Process %0s accessed semaphore key.", $time, name);
        #10;
        sem1.put(1);
        $display("[%0t]: Process %0s released semaphore key.", $time, name);
    endtask
    initial begin
        sem1 = new(2);
        sem2 = new(4);
    end
    initial begin
        fork
            process("P1");
            process("P2");
            process("P3");
        join
    end

    initial begin
        $display("[%0t]: Process P4 trying to acquire 3 keys", $time);
        sem2.get(3);
        $display("[%0t]: Process P4 acquired 3 keys", $time);
        #10;
        sem2.put(1);
        $display("[%0t]: Process P4 released 1 key", $time);
        #5;
        sem2.get(2); 
        $display("[%0t]: Process P4 released 2 key", $time);
    end

    initial begin
        $display("[%0t]: Process P5 trying to acquire 2 keys", $time);
        sem2.get(2);
        $display("[%0t]: Process P5 acquired 2 keys", $time);
        #10;
        sem2.put(2);
        $display("[%0t]: Process P5 released 1 key", $time);
    end

endmodule


