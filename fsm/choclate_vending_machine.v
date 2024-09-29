
module vending_machine(
    input clk,
    input reset,
    input [1:0] coin, 
    output reg [2:0] chocolate 
);

// State Encoding
parameter IDLE = 2'b00, FIVE = 2'b01, TEN = 2'b10, TWENTY = 2'b11;

reg [1:0] current_state, next_state;

// State Transition
always @(posedge clk or posedge reset) begin
    if (reset)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Next State Logic and Output Logic
always @(*) begin
    next_state = current_state; // Default to stay in current state
    chocolate = 3'b000; // Default to no chocolate
    
    case (current_state)
        IDLE: begin
            if (coin == 2'b01)
                next_state = FIVE;
            else if (coin == 2'b10)
                next_state = TEN;
            else if (coin == 2'b11)
                next_state = TWENTY;
        end
        
        FIVE: begin
            chocolate = 3'b001; // Dispense chocolate A
            next_state = IDLE;  // Return to IDLE after dispensing
        end
        
        TEN: begin
            chocolate = 3'b010; // Dispense chocolate B
            next_state = IDLE;  // Return to IDLE after dispensing
        end
        
        TWENTY: begin
            chocolate = 3'b100; // Dispense chocolate C
            next_state = IDLE;  // Return to IDLE after dispensing
        end
    endcase
end

endmodule

module choco_tb();

    // Testbench signals
    reg clk;
    reg reset;
    reg [1:0] coin;
    wire [2:0] chocolate;

    // Instantiate the vending machine module
    vending_machine uut (
        .clk(clk),
        .reset(reset),
        .coin(coin),
        .chocolate(chocolate)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period (100MHz)
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        coin = 2'b00;
        #10;
        
        // Release reset
        reset = 0;

        // Test case 1: Insert 5
        #10 coin = 2'b01;  // Insert 5 units
        #10 coin = 2'b00;  // Wait for chocolate to dispense
        $display("Inserted 5 units, Chocolate: %0b", chocolate);

        // Test case 2: Insert 10
        #10 coin = 2'b10;  // Insert 10 units
        #10 coin = 2'b00;  // Wait for chocolate to dispense
        $display("Inserted 10 units, Chocolate: %0b", chocolate);

        // Test case 3: Insert 20
        #10 coin = 2'b11;  // Insert 20 units
        #10 coin = 2'b00;  // Wait for chocolate to dispense
        $display("Inserted 20 units, Chocolate: %0b", chocolate);

    end

endmodule