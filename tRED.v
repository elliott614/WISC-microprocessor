module tRED ( );

  reg  signed [7:0]  RsLo, RtLo, RsHi, RtHi;
  wire signed [15:0] Rd;
  reg  signed [15:0] interm1, interm2, tResult;

  RED DUT (.Rd, .Rs({RsHi, RsLo}), .Rt({RtHi, RtLo}));

  always begin
    RsHi    = $random  % 256;
    RtHi    = $random  % 256;
    RsLo    = $random  % 256;
    RtLo    = $random  % 256;
    interm1 = RsLo     + RtLo;
    interm2 = RsHi     + RtHi;
    tResult = interm1  + interm2;
    #5;
    $display("RsLo:%D, RsHi:%D, RtLo:%D, RtHi:%D, interm1:%d, interm2:%d, Rd:%d, tResult:%d", RsLo, RsHi, RtLo,RtHi, interm1, interm2, Rd, tResult);
    #5;
  end

  initial #500
    $finish;

endmodule
