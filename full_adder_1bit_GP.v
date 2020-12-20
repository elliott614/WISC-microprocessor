module full_adder_1bit_GP ( Sum, G, P, Cin, A, B );
   input  Cin, A, B;
   output Sum, G, P;

   assign P = A ^ B,

          Sum = P ^ Cin,
          G = A & B;

endmodule
