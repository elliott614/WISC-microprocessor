module ReadDecoder_4_16( input [3:0] RegId, output reg [15:0] Wordline );

  always @(RegId or Wordline)
  begin
    case (RegId)
      4'b0000 : Wordline = 16'b0000000000000001;
      4'b0001 : Wordline = 16'b0000000000000010;
      4'b0010 : Wordline = 16'b0000000000000100;
      4'b0011 : Wordline = 16'b0000000000001000;
      4'b0100 : Wordline = 16'b0000000000010000;
      4'b0101 : Wordline = 16'b0000000000100000;
      4'b0110 : Wordline = 16'b0000000001000000;
      4'b0111 : Wordline = 16'b0000000010000000;
      4'b1000 : Wordline = 16'b0000000100000000;
      4'b1001 : Wordline = 16'b0000001000000000;
      4'b1010 : Wordline = 16'b0000010000000000;
      4'b1011 : Wordline = 16'b0000100000000000;
      4'b1100 : Wordline = 16'b0001000000000000;
      4'b1101 : Wordline = 16'b0010000000000000;
      4'b1110 : Wordline = 16'b0100000000000000;
      4'b1111 : Wordline = 16'b1000000000000000;
      default : Wordline = 16'b0000000000000000;
    endcase
  end

endmodule
