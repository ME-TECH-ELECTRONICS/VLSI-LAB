/*********************************************************/
/*      AUTHOR: METECH                                   */
/*      FILE_NAME: transaction.sv                        */
/*      DESCRIPTION: formating data packet               */
/*      DATE: 03/02/2025                                 */
/*********************************************************/

// Packet type enumeration for defining packet states
typedef enum logic[1:0]{RESET = 0, HEADER = 1, PAYLOAD = 2, PARITY = 3} pkt_type_t;

// Packet class definition
class Packet;
    // Randomizable fields representing packet attributes
    rand bit[7:0] header;
    rand bit[7:0] data;
    rand bit pkt_valid;
    randc bit rd_en_0;
    randc bit rd_en_1;
    randc bit rd_en_2;
    
    // Status signals
    bit vld_out_0;   
    bit vld_out_1;   
    bit vld_out_2;   
    bit err;         
    bit busy;
    bit rst;
    
    // Data output signals
    bit [7:0] dout_0;
    bit [7:0] dout_1;
    bit [7:0] dout_2;
    
    // Parity check logic
    logic[7:0] parity;
    
    // Packet type enumeration variable
    pkt_type_t pkt_type;

    // Constraints to ensure valid header values
    constraint con1 { 
        header[1:0] != 2'b11; 
        header[7:2] != 0; 
        header[7:2] <= 20;
    }

    // Function to copy data from another Packet instance
    function void copy(Packet tmp);
        data = tmp.data;
        pkt_valid = tmp.pkt_valid;
        rd_en_0 = tmp.rd_en_0;
        rd_en_1 = tmp.rd_en_1;
        rd_en_2 = tmp.rd_en_2;
        vld_out_0 = tmp.vld_out_0;
        vld_out_1 = tmp.vld_out_1;
        vld_out_2 = tmp.vld_out_2;
        err = tmp.err;
        busy = tmp.busy;
        dout_0 = tmp.dout_0;
        dout_1 = tmp.dout_1;
        dout_2 = tmp.dout_2;
        parity = tmp.parity;
    endfunction

endclass
