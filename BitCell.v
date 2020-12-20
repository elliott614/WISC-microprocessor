module BitCell( input clk, input rst, input D, input WriteEnable, input ReadEnable1,
  input ReadEnable2, inout Bitline1, inout Bitline2 );

  wire q;

  dff dff (.q(q), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

  assign Bitline1 = ReadEnable1 ? (WriteEnable ? D : q) : 'bz;
  assign Bitline2 = ReadEnable2 ? (WriteEnable ? D : q) : 'bz;

endmodule
