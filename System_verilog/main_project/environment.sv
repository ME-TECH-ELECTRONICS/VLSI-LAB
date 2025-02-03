/*********************************************************************/
/*      AUTHOR: METECH                                               */
/*      FILE_NAME: environment.sv                                    */
/*      DESCRIPTION: Connects driver, generator, mointor &scoreboard */
/*      DATE: 03/02/2025                                             */
/*********************************************************************/

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

// Environment class to instantiate and connect all verification components
class Environment;
    Generator gen; // Generates test packets
    Driver drv; // Drives packets to DUT
    Monitor mon; // Monitors DUT output
    Scoreboard sbd; // Compares expected vs actual results

    mailbox #(Packet) drv_mbx; // Mailbox for driver communication
    mailbox #(Packet) sbd_mbx_in; // Mailbox for input packets to scoreboard
    mailbox #(Packet) sbd_mbx_out; // Mailbox for output packets from scoreboard
    event drv_done; // Event to synchronize driver completion
    virtual router_if vif; // Virtual interface for DUT interaction

    function new(virtual router_if vif);
        drv_mbx = new(); // Initialize driver mailbox
        sbd_mbx_in = new(); // Initialize input mailbox for scoreboard
        sbd_mbx_out = new(); // Initialize output mailbox for scoreboard
        gen = new(drv_mbx, drv_done); // Instantiate generator
        drv = new(drv_mbx, drv_done, vif); // Instantiate driver
        mon = new(sbd_mbx_in, sbd_mbx_out, drv_done, vif); // Instantiate monitor
        sbd = new(sbd_mbx_in, sbd_mbx_out); // Instantiate scoreboard
    endfunction

    task run();
        fork
            gen.run(); // Run generator
            drv.run(); // Run driver
            mon.run(); // Run monitor
            mon.run1(); // Additional monitor function
            sbd.in_run(); // Run input side of scoreboard
            sbd.out_run(); // Run output side of scoreboard
        join
    endtask
endclass
