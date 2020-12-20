module  RED ( Rd, Rs, Rt );
  output [15:0]  Rd;
  input  [15:0]  Rs, Rt;

  wire   Cout00, Cout01, Cout02, Cout10, Cout11, Cout12, Cout20, Cout21, Cout22;
  wire   [8:0]  Sum0, Sum1;

  //bbbb bbbb + dddd dddd
  add_4bit_lookahead Adder00 (.Sum(Sum0[3:0]), .C4(Cout00),   .A   (Rs[3:0]),   .B(Rt[3:0]),     .C0(1'b0)),
                     Adder01 (.Sum(Sum0[7:4]), .C4(Cout01),   .A   (Rs[7:4]),   .B(Rt[7:4]),     .C0(Cout00));
  full_adder_1bit    Adder02 (.Sum(Sum0[8]),   .Cout(Cout02), .Cin (Cout01),    .A(Rs[7]),       .B(Rt[7]));

  //aaaa aaaa + cccc cccc
  add_4bit_lookahead Adder10 (.Sum(Sum1[3:0]), .C4(Cout10),   .A   (Rs[11:8]),  .B(Rt[11:8]),     .C0(1'b0)),
                     Adder11 (.Sum(Sum1[7:4]), .C4(Cout11),   .A   (Rs[15:12]), .B(Rt[15:12]),    .C0(Cout10));
  full_adder_1bit    Adder12 (.Sum(Sum1[8]),   .Cout(Cout12), .Cin (Cout11),    .A(Rs[15]),       .B(Rt[15]));

  //Final addition
  add_4bit_lookahead Adder20 (.Sum(Rd[3:0]),   .C4(Cout20),   .A   (Sum0[3:0]), .B   (Sum1[3:0]), .C0(1'b0)),
                     Adder21 (.Sum(Rd[7:4]),   .C4(Cout21),   .A   (Sum0[7:4]), .B   (Sum1[7:4]), .C0(Cout20)),
                     Adder22 (.Sum(Rd[11:8]),  .C4(Cout22),   .A({4{Sum0[8]}}), .B({4{Sum1[8]}}), .C0(Cout21));

  assign Rd [15:12]        =    {4{Rd[11]}};


endmodule
