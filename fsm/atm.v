module ATM_FSM(
    input clk,
    input rst,
    input card_inserted,
    input pin_correct,
    input withdraw,
    input deposit,
    input balance,
    input [15:0] amount,
    output reg dispense_cash,
    output reg update_balance,
    output reg print_receipt
);

    // State encoding
    parameter IDLE           = 3'b000;
    parameter CHECK_PIN      = 3'b001;
    parameter MENU           = 3'b010;
    parameter WITHDRAW       = 3'b011;
    parameter DEPOSIT        = 3'b100;
    parameter BALANCE_CHECK  = 3'b101;
    parameter DISPENSE_CASH  = 3'b110;
    parameter TRANSACTION_DONE = 3'b111;

    // Current and next state variables
    reg [2:0] PS, NS;

    // State transition logic (sequential)
    always @(posedge clk) begin
        if (rst)
            PS <= IDLE;
        else
            PS <= NS;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (PS)
            IDLE: begin
                if (card_inserted)
                    NS = CHECK_PIN;
                else
                    NS = IDLE; //Card not inserted
            end

            CHECK_PIN: begin
                if (pin_correct)
                    NS = MENU;
                else
                    NS = IDLE;  // Incorrect PIN, go back to idle
            end

            MENU: begin
                if (withdraw)
                    NS = WITHDRAW;
                else if (deposit)
                    NS = DEPOSIT;
                else if (balance)
                    NS = BALANCE_CHECK;
                else
                    NS = MENU;
            end

            WITHDRAW: begin
                NS = DISPENSE_CASH;
            end

            DEPOSIT: begin
                NS = TRANSACTION_DONE;
            end

            BALANCE_CHECK: begin
                NS = TRANSACTION_DONE;
            end

            DISPENSE_CASH: begin
                NS = TRANSACTION_DONE;
            end

            TRANSACTION_DONE: begin
                NS = IDLE;  
            end

            default: NS = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        dispense_cash <= 0;
        update_balance <= 0;
        print_receipt <= 0;

        case (PS)
            WITHDRAW: begin
                dispense_cash <= 1;
                update_balance <= 1;
            end

            DEPOSIT: begin
                update_balance <= 1;
            end

            BALANCE_CHECK: begin
                print_receipt <= 1;
            end
        endcase
    end

endmodule


module ATM_tb;

    // Inputs
    reg clk;
    reg reset;
    reg card_inserted;
    reg pin_correct;
    reg withdraw;
    reg deposit;
    reg balance;
    reg [15:0] amount;

    // Outputs
    wire dispense_cash;
    wire update_balance;
    wire print_receipt;

    // Instantiate the ATM FSM module
    ATM_FSM uut (clk, reset, card_inserted, pin_correct, withdraw, deposit, balance, amount, dispense_cash, update_balance, print_receipt);

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test procedure
    initial begin
        // Initialize inputs
        reset = 1;
        card_inserted = 0;
        pin_correct = 0;
        withdraw = 0;
        deposit = 0;
        balance = 0;
        amount = 16'd0;
        #10 reset = 0;

        // Test case 1: Insert card, correct PIN, withdraw money
        #10 card_inserted = 1;
        #10 pin_correct = 1; 
        #10 withdraw = 1;
        amount = 16'd500;  // Example withdrawal amount
        #30;

        // Test case 2: Insert card, correct PIN, check balance
        #10 card_inserted = 1;
        pin_correct = 1;
        withdraw = 0;
        deposit = 0;
        balance = 1;
        #30;

        // Test case 3: Insert card, correct PIN, deposit money
        #10 card_inserted = 1;
        pin_correct = 1;
        withdraw = 0;
        balance = 0;
        deposit = 1;
        amount = 16'd300;  // Example deposit amount
        #30;
    end

    // Monitor outputs
    initial begin
        $monitor("Time = %0t | card_inserted = %b | pin_correct = %b | withdraw = %b | deposit = %b | amount = %0d | balance = %b | dispense_cash = %b | update_balance = %b | print_receipt = %b", $time, card_inserted, pin_correct, withdraw, deposit, amount, balance, dispense_cash, update_balance, print_receipt);
    end

endmodule