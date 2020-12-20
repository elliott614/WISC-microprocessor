module full_adder_1bit ( Sum, Cout, Cin, A, B );
   input  Cin, A, B;
   output Sum, Cout;

   assign AxorB = A ^ B; //A XOR B, value used in sum and Cout logic

   assign Sum = AxorB ^ Cin;
   assign Cout = A & B | Cin & AxorB;

endmodule
