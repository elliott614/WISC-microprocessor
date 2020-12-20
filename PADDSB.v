module PADDSB ( Rd, Rs, Rt );
  input  [15:0] Rs, Rt;  //input data values
  output [15:0] Rd;  //sum output
  wire   [3:0]  Ovfl;

  add_4bit_lookahead_sat S0 (.Sum(Rd[3:0]),   .Ovfl(Ovfl[0]), .A(Rs[3:0]),   .B(Rt[3:0]),   .C0(1'b0)),
                         S1 (.Sum(Rd[7:4]),   .Ovfl(Ovfl[1]), .A(Rs[7:4]),   .B(Rt[7:4]),   .C0(1'b0)),
                         S2 (.Sum(Rd[11:8]),  .Ovfl(Ovfl[2]), .A(Rs[11:8]),  .B(Rt[11:8]),  .C0(1'b0)),
                         S3 (.Sum(Rd[15:12]), .Ovfl(Ovfl[3]), .A(Rs[15:12]), .B(Rt[15:12]), .C0(1'b0));

endmodule
