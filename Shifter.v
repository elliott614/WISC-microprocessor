module Shifter (  Rd, Rs, Imm, mode );
  output [15:0]   Rd;
  input  [15:0]   Rs;
  input  [3:0]    Imm;
  input  [1:0]    mode;    //00=SLL, 01=SRA, 10=ROR

  wire   [15:0]   shift8,  shift4,  shift2, shift1,
                  sll8,    sll4,    sll2,     sll1,
                  sra8,    sra4,    sra2,     sra1,
                  ror8,    ror4,    ror2,     ror1,
                  stage1,  stage2,  stage3;

  assign sll8   = Rs     << 8,
         sll4   = stage1 << 4,
         sll2   = stage2 << 2,
         sll1   = stage3 << 1,

         sra8   = {{8{Rs[15]}},       Rs[15:8]},
         sra4   = {{4{Rs[15]}},   stage1[15:4]},
         sra2   = {{2{Rs[15]}},   stage2[15:2]},
         sra1   = {   Rs[15]  ,   stage3[15:1]},

         ror8   = {    Rs[7:0],       Rs[15:8]},
         ror4   = {stage1[3:0],   stage1[15:4]},
         ror2   = {stage2[1:0],   stage2[15:2]},
         ror1   = {stage3[0]  ,   stage3[15:1]},

         stage1 =     Imm[3]  ?   shift8   :  Rs,
         stage2 =     Imm[2]  ?   shift4   :  stage1,
         stage3 =     Imm[1]  ?   shift2   :  stage2,
         Rd     =     Imm[0]  ?   shift1   :  stage3;

  Mux3to1_16bit m0(.out(shift8), .in0(sll8), .in1(sra8), .in2(ror8), .sel(mode)),
                m1(.out(shift4), .in0(sll4), .in1(sra4), .in2(ror4), .sel(mode)),
                m2(.out(shift2), .in0(sll2), .in1(sra2), .in2(ror2), .sel(mode)),
                m3(.out(shift1), .in0(sll1), .in1(sra1), .in2(ror1), .sel(mode));

endmodule
