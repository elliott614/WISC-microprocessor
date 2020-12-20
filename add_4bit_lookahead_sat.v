module add_4bit_lookahead_sat ( Sum, Ovfl, A, B, C0 );
   //saturates to max/min 4-bit value during overflow
  input  [3:0]       A, B;
  input              C0;
  output [3:0]       Sum;
  output             Ovfl;     //To indicate overflow
  wire   [3:0]       Overflow; //Overflow is max or min 4-bit value
  wire   [3:0]       SumNoSat; //Sum before saturation
  wire               C4;       //Carry-out

  assign Overflow  = A[3] & B[3] ? 4'b1000 : 4'b0111;

  assign Ovfl      = (A[3] ~^ B[3]) & (B[3] ^ SumNoSat[3]);

  assign Sum       = Ovfl ? Overflow : SumNoSat; //if overflow, saturate

  add_4bit_lookahead adder(.Sum(SumNoSat), .C4(C4), .A, .B, .C0(C0));

endmodule
