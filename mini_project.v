task pktm_gen_5;  // packet generation payload 5
  reg [7:0] header, payload_data, parity;
  reg [8:0] payloadlen;

  begin
    parity = 0;
    wait (!busy) begin
      @(negedge clk);
      payloadlen = 5;
      packet_valid = 1'b1;
      header = {payloadlen, 2'b10};
      datain = header;
      parity = parity ^ datain;
    end
    @(negedge clk); // 1 1 1 1 1 1 

    for (i = 0; i < payloadlen; i = i + 1) begin
      wait (!busy) begin
        @(negedge clk);
        payload_data = {$random} % 256;
        datain = payload_data;
        parity = parity ^ datain;
      end
    end

    wait (!busy) begin
      @(negedge clk);
      packet_valid = 0;
      datain = parity;
    end
    repeat (2) @(negedge clk);
    read_enb_2 = 1'b1;

    wait (DUT.FIFO_2.empty) @(negedge clk) read_enb_2 = 0;
  end

endtask
