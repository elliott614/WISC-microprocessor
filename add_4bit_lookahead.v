module add_4bit_lookahead ( Sum, C4, A, B, C0 );
   input  [3:0] A, B; //Input values
   input        C0;
   output [3:0] Sum; //sum output
   output       C4;
   wire    G0,  G1,  G2,  G3,  P0,  P1,  P2,  P3,  C1,  C2,  C3,  C4;

   assign  C1 = G0 | P0 & C0;
   assign  C2 = G1 | G0 & P1 | C0 & P0 & P1;
   assign  C3 = G2 | G1 & P2 | G0 & P1 & P2 | C0 & P0 & P1 & P2;
   assign  C4 = G3 | G2 & P3 | G1 & P2 & P3 | G0 & P1 & P2 & P3 | C0 & P0 & P1 & P2 & P3;

   full_adder_1bit_GP adders [3:0] (.Sum(Sum), .G({G3, G2, G1, G0}), .P({P3, P2, P1, P0}), .Cin({C3, C2, C1, C0}), .A(A), .B(B));

endmodule
