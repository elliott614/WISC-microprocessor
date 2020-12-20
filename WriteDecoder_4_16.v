module WriteDecoder_4_16( input [3:0] RegId, input WriteReg, output [15:0] Wordline );

  reg [15:0]    Wordlinereg;
  assign        Wordline    = {16{WriteReg}} & Wordlinereg;

  always @(RegId)
  begin
    case (RegId)
      4'b0000 : Wordlinereg =  16'b0000000000000001;
      4'b0001 : Wordlinereg =  16'b0000000000000010;
      4'b0010 : Wordlinereg =  16'b0000000000000100;
      4'b0011 : Wordlinereg =  16'b0000000000001000;
      4'b0100 : Wordlinereg =  16'b0000000000010000;
      4'b0101 : Wordlinereg =  16'b0000000000100000;
      4'b0110 : Wordlinereg =  16'b0000000001000000;
      4'b0111 : Wordlinereg =  16'b0000000010000000;
      4'b1000 : Wordlinereg =  16'b0000000100000000;
      4'b1001 : Wordlinereg =  16'b0000001000000000;
      4'b1010 : Wordlinereg =  16'b0000010000000000;
      4'b1011 : Wordlinereg =  16'b0000100000000000;
      4'b1100 : Wordlinereg =  16'b0001000000000000;
      4'b1101 : Wordlinereg =  16'b0010000000000000;
      4'b1110 : Wordlinereg =  16'b0100000000000000;
      4'b1111 : Wordlinereg =  16'b1000000000000000;
      default : Wordlinereg =  16'b0000000000000000;
    endcase
  end

endmodule
