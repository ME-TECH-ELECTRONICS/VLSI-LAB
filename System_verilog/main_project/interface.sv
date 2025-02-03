/*********************************************************/
/*      AUTHOR: METECH                                   */
/*      FILE_NAME: interface.sv                          */
/*      DESCRIPTION: Actual interface definition         */
/*      DATE: 03/02/2025                                 */
/*********************************************************/

interface router_if();
    logic clk;           // Clock signal
    logic rst;           // Reset signal
    logic [7:0] data;    // Data input
    logic pkt_valid;     // Packet valid signal
    logic rd_en_0;       // Read enable signal for output 0
    logic rd_en_1;       // Read enable signal for output 1
    logic rd_en_2;       // Read enable signal for output 2
    logic vld_out_0;     // Valid output signal for output 0
    logic vld_out_1;     // Valid output signal for output 1
    logic vld_out_2;     // Valid output signal for output 2
    logic err;           // Error signal
    logic busy;          // Busy signal indicating router activity
    logic [7:0] dout_0;  // Data output for output 0
    logic [7:0] dout_1;  // Data output for output 1
    logic [7:0] dout_2;  // Data output for output 2

    initial clk = 0; // Initialize clock to 0
    always #5 clk = ~clk; // Clock toggles every 5 time units

endinterface
