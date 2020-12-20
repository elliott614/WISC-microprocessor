module Mux3to1_16bit ( out, in0, in1, in2, sel );
  output [15:0] out;
  input  [15:0] in0, in1, in2;
  input  [1:0]  sel;

  wire   [15:0] interm;

  Mux2to1_16bit Mux0(.out(interm), .in0(in0),    .in1(in1), .sel(sel[0])),
                Mux1(.out(out),    .in0(interm), .in1(in2), .sel(sel[1]));

endmodule
