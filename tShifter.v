module tShifter ( );
  reg  signed [15:0] Rs;
  reg         [3:0]  Imm;
  wire        [15:0] sll, sra,  ror;
  wire        [15:0] tsll, tsra, tror;
  wire        [31:0] trorhi;

  assign  tsll   =  Rs            << Imm;
  assign  tsra   =  Rs           >>> Imm;
  assign  trorhi = {Rs, 16'h0000} >> Imm;
  assign  tror   = (Rs            >> Imm) |  trorhi[15:0];

  Shifter SLL(.Rd(sll), .Rs(Rs), .Imm(Imm), .mode(2'b00)),
          SRA(.Rd(sra), .Rs(Rs), .Imm(Imm), .mode(2'b01)),
          ROR(.Rd(ror), .Rs(Rs), .Imm(Imm), .mode(2'b10));

  always begin
          Rs  = $random % 65536;
          Imm = $random % 16;
          #5;
          $display("Rs:0x%h, Imm:%d, SLL:0x%h, tSLL:0x%h, SRA:0x%h, tSRA:0x%h, ROR:0x%h, tROR:0x%h",
                    Rs,      Imm,    sll,      tsll,      sra,      tsra,      ror,      tror);
          #5;
  end

  initial #500
          $finish;

endmodule
