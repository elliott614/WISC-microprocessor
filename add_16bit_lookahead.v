module add_16bit_lookahead ( output [15:0] Sum, output C16, input [15:0] A, input [15:0] B, input C0 );

  wire C4, C8, C12;

  add_4bit_lookahead fa [3:0] ( .Sum(Sum), .C4({C16, C12, C8, C4}), .A(A), .B(B), .C0({C12, C8, C4, C0}) );

endmodule
