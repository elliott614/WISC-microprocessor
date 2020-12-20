module ADDSUB ( Rd, V, Rs, Rt, mode );
  output [15:0] Rd;
  output        V;       //Overflow
  input  [15:0] Rs, Rt;
  input         mode;    //1=sub, 0=add
  wire          Ovfl;

  wire   [15:0] Sum, B, Overflow;
  wire   Cout0, Cout1, Cout2, Cout3, C0;

  assign B        =    mode  ? ~Rt        :                  Rt;
  assign Overflow =  Rs[15]  &  B[15]     ? 16'h8000 : 16'h7FFF;
  assign Ovfl     = (Rs[15] ~^  B[15])    &   (B[15] ^ Sum[15]); //operands have same sign AND sign changes
  assign Rd       =    Ovfl  ?  Overflow  :                 Sum;
  assign V        =    Ovfl;

  add_4bit_lookahead Adder0 (.Sum(Sum[3:0]),   .C4(Cout0), .A(Rs[3:0]),   .B(B[3:0]),   .C0(mode)),
                     Adder1 (.Sum(Sum[7:4]),   .C4(Cout1), .A(Rs[7:4]),   .B(B[7:4]),   .C0(Cout0)),
                     Adder2 (.Sum(Sum[11:8]),  .C4(Cout2), .A(Rs[11:8]),  .B(B[11:8]),  .C0(Cout1)),
                     Adder3 (.Sum(Sum[15:12]), .C4(Cout3), .A(Rs[15:12]), .B(B[15:12]), .C0(Cout2));

endmodule
