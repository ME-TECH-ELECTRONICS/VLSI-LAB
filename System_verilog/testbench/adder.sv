module adder_8bit (adder_intf intf);
    assign {intf.carry, intf.sum} = intf.a + intf.b;
endmodule