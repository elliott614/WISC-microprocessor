module Register( input clk, input rst, input [15:0] D, input WriteReg, input ReadEnable1, input
                 ReadEnable2, inout [15:0] Bitline1, inout [15:0] Bitline2, input [15:0] bytesel );

  wire    [15:0]     BL1, BL2, we;

  assign  Bitline1 = BL1,
          Bitline2 = BL2,
          we       = WriteReg ? bytesel : 16'h0000;

  BitCell bc [15:0] (
         .clk(clk),
         .rst(rst),
         .D(D),
         .WriteEnable(we),
         .ReadEnable1(ReadEnable1),
         .ReadEnable2(ReadEnable2),
         .Bitline1(BL1),
         .Bitline2(BL2)
  );

endmodule
