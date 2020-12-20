module RegisterFile( input clk, input rst, input [3:0] SrcReg1, input [3:0] SrcReg2, input [3:0]
  DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout [15:0] SrcData2);

  wire [15:0] rsel1, rsel2, BL1, BL2, wd;

  assign      SrcData1 =    BL1;
  assign      SrcData2 =    BL2;

  ReadDecoder_4_16          RDec1 (.RegId(SrcReg1), .Wordline(rsel1)),
                            RDec2 (.RegId(SrcReg2), .Wordline(rsel2));
  WriteDecoder_4_16         WD2   (.RegId(DstReg),  .WriteReg(WriteReg), .Wordline(wd));

  Register R [15:0] (
              .clk(clk),
              .rst(rst),
              .D(DstData),
              .WriteReg(wd),
              .ReadEnable1(rsel1),
              .ReadEnable2(rsel2),
              .Bitline1(BL1),
              .Bitline2(BL2)
  );


endmodule
