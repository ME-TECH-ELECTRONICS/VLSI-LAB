`include "uvm_macros.svh" // Include UVM macros
import uvm_pkg::*; // Import UVM package

interface router_if(input logic clk, input logic rst);
    // Data input signal
    logic [7:0] d_in;
    
    // Packet valid signal, indicates a valid packet is present
    logic pkt_valid;
    
    // Read enable signals for three output ports
    logic rd_en_0, rd_en_1, rd_en_2;
    
    // Valid output signals indicating data availability at each output port
    logic vld_out_0, vld_out_1, vld_out_2;
    
    // Error signal, indicates an invalid condition or error
    logic err;
    
    // Busy signal, indicates the router is processing data
    logic busy;
    
    // Data output signals for three output ports
    logic [7:0] dout_0, dout_1, dout_2;
endinterface



// Transaction class
class transaction extends uvm_sequence_item;
    // Randomized input data and header
    rand logic [7:0] d_in; // Data input
    rand bit [7:0] header; // Header containing routing information
    
    // Control signals
    logic pkt_valid; // Indicates if the packet is valid
    logic rd_en_0 = 1, rd_en_1 = 1, rd_en_2 = 1; // Read enable signals for three output channels
    
    // Additional signals
    logic [7:0] parity = 0; // Parity bit for error detection
    logic vld_out_0, vld_out_1, vld_out_2; // Validity signals for output channels
    logic err, busy; // Error and busy flags
    logic [7:0] dout_0, dout_1, dout_2; // Output data for three channels

    // Constraints to ensure valid header values
    constraint con1 { 
        header[1:0] != 2'b11; // Avoid using header values with lower 2 bits as '11'
        header[7:2] inside {[1:30]}; // Restrict header values to a valid range
    }

    // Registering the transaction class with UVM factory
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(d_in, UVM_DEFAULT);
        `uvm_field_int(header, UVM_DEFAULT);
        `uvm_field_int(parity, UVM_DEFAULT);
        `uvm_field_int(pkt_valid, UVM_DEFAULT);
        `uvm_field_int(rd_en_0, UVM_DEFAULT);
        `uvm_field_int(rd_en_1, UVM_DEFAULT);
        `uvm_field_int(rd_en_2, UVM_DEFAULT);
        `uvm_field_int(vld_out_0, UVM_DEFAULT);
        `uvm_field_int(vld_out_1, UVM_DEFAULT);
        `uvm_field_int(vld_out_2, UVM_DEFAULT);
        `uvm_field_int(err, UVM_DEFAULT);
        `uvm_field_int(busy, UVM_DEFAULT);
        `uvm_field_int(dout_0, UVM_DEFAULT);
        `uvm_field_int(dout_1, UVM_DEFAULT);
        `uvm_field_int(dout_2, UVM_DEFAULT);
    `uvm_object_utils_end
    
    // Constructor function
    function new(string name = "TRANSACTION");
        super.new(name);
    endfunction
endclass


class sequences extends uvm_sequence #(transaction);
    // Declare a transaction object
    transaction trans;

    // Register the sequence with the UVM factory
    `uvm_object_utils(sequences)
    
    // Constructor
    function new(string name = "SEQUENCES");
        super.new(name);
    endfunction
    
    // Main sequence task
    virtual task body();
        bit [7:0] header;  // Variable to store the header
        int count;          // Number of payload bytes
        bit [7:0] parity = 0; // Parity calculation variable
        int prev = 0;       // Stores the previous data value to ensure variability

        // Send Header
        trans = transaction::type_id::create("trans"); // Create transaction object
        trans.pkt_valid = 1;  // Indicate packet is valid
        start_item(trans);  
        assert(trans.randomize()); // Randomize the transaction fields
        trans.d_in = trans.header; // Assign header to data input
        header = trans.header; // Store header value for later use
        finish_item(trans);  

        count = header[7:2]; // Extract the count from the header (assuming upper bits represent count)
        parity ^= header; // Initialize parity with header value
        
        // Generate Payload
        repeat (count) begin 
            trans = transaction::type_id::create("trans"); // Create new transaction object
            trans.pkt_valid = 1; // Keep packet valid for payload transmission
            start_item(trans);
            assert(trans.randomize()); // Randomize the transaction fields
            
            // Ensure the payload data is not repetitive
            trans.d_in = trans.d_in == 0 ? $random : 
                         trans.d_in == prev ? $random : trans.d_in;
            prev = trans.d_in; // Store previous value to avoid repetition
            
            parity ^= trans.d_in; // Update parity with payload data
            finish_item(trans);
        end
        
        // Send Parity
        trans = transaction::type_id::create("trans"); // Create transaction for parity byte
        start_item(trans);
        trans.pkt_valid = 0; // Indicate end of packet
        trans.d_in = parity; // Assign computed parity value
        finish_item(trans);
    endtask
endclass


class driver extends uvm_driver #(transaction);
    // Register the driver as a UVM component
    `uvm_component_utils(driver)
    
    // Virtual interface handle to interact with DUT
    virtual router_if vif;
    
    // Transaction object to hold stimulus data
    transaction trans;
    
    int len = 0;    // Stores the length of the packet
    int count = 0;  // Counter for tracking the number of transmitted transactions

    // Constructor
    function new(string name = "DRIVER", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // Build phase: Initialize transaction object and get virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create an instance of the transaction class
        trans = transaction::type_id::create("trans", this);
        
        // Retrieve the virtual interface from the UVM configuration database
        if (!uvm_config_db#(virtual router_if)::get(this, "", "vif", vif))
            `uvm_fatal("router_driver", "Virtual interface not set")
    endfunction

    // Run phase: Drive transactions to the DUT
    task run_phase(uvm_phase phase);
        // Wait until the DUT is not busy
        wait(vif.busy == 0);
        @(negedge vif.clk) // Synchronize with the negative clock edge

        // Fetch the first transaction from the sequence
        seq_item_port.get_next_item(trans);
        
        // Drive initial packet information to the DUT
        vif.pkt_valid = trans.pkt_valid;
        vif.d_in = trans.d_in;
        
        // Extract packet length from the data field
        len = int'(trans.d_in[7:2] + 1);
        
        // Indicate that the transaction processing is done
        seq_item_port.item_done();
        @(negedge vif.clk)

        // Forever loop to drive subsequent transactions
        forever begin
            // Wait for DUT to be ready
            wait(vif.busy == 0);
            @(negedge vif.clk)

            // Fetch the next transaction from the sequence
            seq_item_port.get_next_item(trans);

            // Drive transaction data to the DUT
            vif.pkt_valid = trans.pkt_valid;
            vif.d_in = trans.d_in;
            vif.rd_en_0 = trans.rd_en_0;
            vif.rd_en_1 = trans.rd_en_1;
            vif.rd_en_2 = trans.rd_en_2;

            // Indicate that the transaction processing is done
            seq_item_port.item_done();
            
            // Increment the transaction counter
            count = count + 1;
        end
    endtask
endclass


// Monitor
class monitor extends uvm_monitor;
    // Register the monitor as a UVM component
    `uvm_component_utils(monitor)
    
    // Virtual interface handle to interact with DUT
    virtual router_if vif;
    
    // Transaction object to capture monitored data
    transaction trans;
    
    // Analysis port to send captured transactions to the scoreboard or other components
    uvm_analysis_port #(transaction) send;
    
    // Constructor
    function new(string name = "MONITOR", uvm_component parent = null);
        super.new(name, parent);
        
        // Create analysis port to send observed data
        send = new("send", this);
    endfunction
    
    // Build phase: Initialize transaction object and get virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create a transaction object to store captured data
        trans = transaction::type_id::create("trans");
        
        // Retrieve the virtual interface from the UVM configuration database
        if (!uvm_config_db#(virtual router_if)::get(this, "", "vif", vif))
            `uvm_fatal("monitor", "Virtual interface not set")
    endfunction
    
    // Run phase: Capture signals from the DUT continuously
    task run_phase(uvm_phase phase);
        forever begin
            @(negedge vif.clk); // Sample data on the negative clock edge
            
            // Capture DUT output signals into the transaction object
            trans.dout_0     = vif.dout_0;
            trans.dout_1     = vif.dout_1;
            trans.dout_2     = vif.dout_2;
            trans.vld_out_0  = vif.vld_out_0;
            trans.vld_out_1  = vif.vld_out_1;
            trans.vld_out_2  = vif.vld_out_2;
            trans.err        = vif.err;
            trans.busy       = vif.busy;
            trans.d_in       = vif.d_in;
            
            // Send the captured transaction to other UVM components (e.g., scoreboard)
            send.write(trans);
        end
    endtask
endclass


// Scoreboard
class scoreboard extends uvm_scoreboard;
    // Register the scoreboard as a UVM component
    `uvm_component_utils(scoreboard)
    
    // Queues to store input and output streams
    int in_stream[$], out_stream[$];

    bit [7:0] header = 0; // Stores the packet header
    int int_parity = 0;   // Variable to store calculated parity
    
    int prev_d_in = 0, prev_d_out = 0; // Variables to track previous data values

    // Transaction object to hold received data
    transaction trans;

    // Analysis implementation port to receive transactions from the monitor
    uvm_analysis_imp #(transaction, scoreboard) recv;
    
    // Constructor
    function new(string name = "SCOREBOARD", uvm_component parent = null);
        super.new(name, parent);
        
        // Initialize analysis port to receive monitored transactions
        recv = new("send", this);
    endfunction
    
    // Build phase: Initialize transaction object
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create a transaction instance
        trans = transaction::type_id::create("trans", this);
    endfunction
    
    // Write function: Called when monitor sends a transaction
    virtual function void write(input transaction t);
        trans = t;
        
        // Call the function to check the received packet
        check_packet(trans);
    endfunction

    // Function to verify packet correctness
    function void check_packet(transaction pkt);
        // Capture input data if it has changed
        if(pkt.d_in != prev_d_in) begin
            in_stream.push_back(pkt.d_in);
            prev_d_in = pkt.d_in;
            
            // Store the first byte as the header
            if(in_stream.size() == 1) header = pkt.d_in;
        end

        // Capture valid output data from output port 0
        if(pkt.rd_en_0 && pkt.vld_out_0 && (pkt.dout_0 != 8'b0)) begin
            out_stream.push_back(pkt.dout_0);
            prev_d_out = pkt.dout_0;
            if(out_stream.size() == header[7:2] + 1) checkParity();
        end
        // Capture valid output data from output port 1
        else if(pkt.rd_en_1 && pkt.vld_out_1 && (pkt.dout_1 != 8'b0)) begin
            out_stream.push_back(pkt.dout_1);
            prev_d_out = pkt.dout_1;
            if(out_stream.size() == header[7:2] + 1) checkParity();
        end
        // Capture valid output data from output port 2
        else if(pkt.rd_en_2 && pkt.vld_out_2 && (pkt.dout_2 != 8'b0)) begin
            out_stream.push_back(pkt.dout_2);
            prev_d_out = pkt.dout_2;
            if(out_stream.size() == header[7:2] + 1) checkParity();
        end
    endfunction

    function void checkParity();
        // Compute parity over received output data
        foreach(out_stream[i]) begin
            int_parity ^= out_stream[i];
        end
        
        // Compare computed parity with the last received input byte (expected parity)
        if(int_parity == in_stream[$]) begin
            out_stream.push_back(int_parity);
            
            // Display success message
            `uvm_info("SCOREBOARD", "/****************************************************************************/", UVM_LOW);
            `uvm_info("SCOREBOARD", "/* Successfully verified Router 1x3", UVM_LOW);
            `uvm_info("SCOREBOARD", $sformatf("/* Input:  %0p", in_stream), UVM_LOW);
            `uvm_info("SCOREBOARD", $sformatf("/* Output: %0p", out_stream), UVM_LOW);
            `uvm_info("SCOREBOARD", "/****************************************************************************/", UVM_LOW);
        end
        else begin
            // Display error message if parity check fails
            $display("Received corrupted data");
        end
        
    endfunction
endclass


class agent extends uvm_agent;
    // Register the agent as a UVM component
    `uvm_component_utils(agent)

    // Sequencer to generate and control stimulus transactions
    uvm_sequencer #(transaction) sqr;

    // Driver to drive stimulus into the DUT
    driver drv;

    // Monitor to capture DUT responses
    monitor mon;

    // Constructor
    function new(string comp = "AGENT", uvm_component parent = null);
        super.new(comp, parent);
    endfunction

    // Build phase: Create instances of sequencer, driver, and monitor
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Instantiate sequencer, driver, and monitor
        sqr = uvm_sequencer#(transaction)::type_id::create("sqr", this);
        drv = driver::type_id::create("drv", this);
        mon = monitor::type_id::create("mon", this);
    endfunction

    // Connect phase: Connect sequencer to driver
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the sequencer's transaction output to the driver's input
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
  
endclass


// Environment
class environment extends uvm_env;
    // Register the environment as a UVM component
    `uvm_component_utils(environment)
    
    // Declare agent and scoreboard components
    agent agt;      // Agent handles stimulus generation and DUT interaction
    scoreboard sbd; // Scoreboard verifies DUT output against expected results
    
    // Constructor
    function new(string name = "ENVIRONMENT", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // Build phase: Instantiate agent and scoreboard
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
        
        // Create instances of the agent and scoreboard
        agt = agent::type_id::create("agt", this);
        sbd = scoreboard::type_id::create("sbd", this);
    endfunction

    // Connect phase: Connect the monitor's analysis port to the scoreboard
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Link the monitor's output (from agent) to the scoreboard's input
        agt.mon.send.connect(sbd.recv);
    endfunction 
endclass

// Test
class test extends uvm_test;
    // Register the test class as a UVM component
    `uvm_component_utils(test)
    
    // Declare environment and sequence instances
    environment env; // Environment containing agent and scoreboard
    sequences seq;   // Sequence to generate stimulus for the DUT
    
    // Constructor
    function new(string name = "TEST", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    // Build phase: Create instances of the environment and sequence
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Instantiate environment and sequence
        env = environment::type_id::create("env", this);
        seq = sequences::type_id::create("seq");
    endfunction
    
    // Run phase: Execute the test sequence
    virtual task run_phase(uvm_phase phase);
        // Raise an objection to keep the test running
        phase.raise_objection(this);
        
        // Start the sequence on the agent's sequencer
        seq.start(env.agt.sqr);
        
        // Wait for 100 time units to allow the test to complete
        #100;
        
        // Drop the objection to allow the test to end
        phase.drop_objection(this);
    endtask
endclass


module tb_top;
    // Declare clock and reset signals
    logic clk = 0;
    logic rst;

    // Clock generation: Toggles every 5 time units to create a 10-time-unit period
    always #5 clk = ~clk;

    // Instantiate the interface (router_if) and connect it to clock and reset
    router_if tb_if (clk, rst);

    // Instantiate the Design Under Test (DUT)
    router DUT (
        tb_if.clk,        // Clock input
        tb_if.rst,        // Reset input
        tb_if.d_in,       // Data input
        tb_if.pkt_valid,  // Packet valid signal
        tb_if.rd_en_0,    // Read enable for output 0
        tb_if.rd_en_1,    // Read enable for output 1
        tb_if.rd_en_2,    // Read enable for output 2
        tb_if.vld_out_0,  // Valid output flag for output 0
        tb_if.vld_out_1,  // Valid output flag for output 1
        tb_if.vld_out_2,  // Valid output flag for output 2
        tb_if.err,        // Error signal
        tb_if.busy,       // Busy signal
        tb_if.dout_0,     // Data output 0
        tb_if.dout_1,     // Data output 1
        tb_if.dout_2      // Data output 2
    );

    // Initialize and run the UVM test
    initial begin
        // Set the virtual interface for UVM testbench components
        uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt*", "vif", tb_if);
        
        // Start the test named "test"
        run_test("test");
    end

    // Reset sequence
    initial begin
        rst = 0;  // Assert reset
        #10 rst = 1;  // De-assert reset after 10 time units
    end

    // Dump waveform data for debugging
    initial begin
        $dumpfile("dump.vcd");  // Specify the waveform file
        $dumpvars;              // Dump all variables
        #1000 $finish;          // Stop simulation after 1000 time units
    end
endmodule

