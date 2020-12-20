module Mux2to1_16bit ( out, in0, in1, sel );
  output [15:0] out;
  input  [15:0] in0, in1;
  input         sel;

  assign  out = sel ? in1 : in0;

endmodule
