module tPADDSB ( );
  reg  signed [3:0] A, B, C, D, E, F, G, H; //subwords to be added
  wire signed [3:0] AE, BF, CG, DH;         //sums calculated by PADDSB
  wire signed [4:0] tAE, tBF, tCG, tDH, ttAE, ttBF, ttCG, ttDH;

  assign tAE = A + E,
         tBF = B + F,
         tCG = C + G,
         tDH = D + H,

         ttAE = tAE > 7 ? 5'b00111 : (tAE < -8 ? 5'b11000 : tAE),
         ttBF = tBF > 7 ? 5'b00111 : (tBF < -8 ? 5'b11000 : tBF),
         ttCG = tCG > 7 ? 5'b00111 : (tCG < -8 ? 5'b11000 : tCG),
         ttDH = tDH > 7 ? 5'b00111 : (tDH < -8 ? 5'b11000 : tDH);

  PADDSB DUT (.Rd({AE, BF, CG, DH}), .Rs({A, B, C, D}), .Rt({E, F, G, H}));

  always begin
    A = $random % 16;
    B = $random % 16;
    C = $random % 16;
    D = $random % 16;
    E = $random % 16;
    F = $random % 16;
    G = $random % 16;
    H = $random % 16;
    #5
    $display ("%d + %d = %d? %d\n%d + %d = %d? %d\n%d + %d = %d? %d\n%d + %d = %d? %d\n",
                A, E, AE, ttAE, B, F, BF, ttBF, C, G, CG, ttCG, D, H, DH, ttDH);
    #5;
  end

  initial
    #1000 $finish;

endmodule
