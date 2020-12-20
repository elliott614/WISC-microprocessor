module ALU  ( alu_out, Z, V, N, alu_in1, alu_in2, Opcode, clk, rst );
  output reg [15:0]  alu_out;
  output             Z,     V,    N;                //flag register outputs
  input      [15:0]  alu_in1,     alu_in2;
  input      [3:0]   Opcode;
  input              clk,   rst;

  wire       [3:0]   Imm;
  assign             Imm =  alu_in2[3:0];

  wire       [15:0]  addop2;                        //so LW works
  assign             addop2   = Opcode[3] ? {alu_in2[14:0], 1'b0} : alu_in2;

  reg                NN,    ZZ,   VV;               //combinational inputs to flag register
  wire       [15:0]  Shift, RED,  PADDSB,   ADDSUB; //results of operations
  wire               Ovfl;                          //Signal  from  ADD/SUB
  wire               subtract;
  assign             subtract = Opcode[3] ? 1'b0 : Opcode[0];

  Shifter Shiftmodule  (.Rd(Shift),  .Rs(alu_in1), .Imm(Imm),     .mode(Opcode[1:0]));
  RED     REDmodule    (.Rd(RED),    .Rs(alu_in1), .Rt(alu_in2));
  PADDSB  PADDSBmodule (.Rd(PADDSB), .Rs(alu_in1), .Rt(alu_in2));
  ADDSUB  ADDSUBmodule (.Rd(ADDSUB), .Rs(alu_in1), .Rt(addop2),  .mode(subtract),    .V(Ovfl));

  always @ (*)
  begin
    case(Opcode[2:0])
      3'b000, 3'b001   :
        begin             //ADDSUB
         {alu_out, NN, VV}  =   {ADDSUB,       ADDSUB[15], Ovfl};
          ZZ                =   (ADDSUB  ==  16'h0000) ? 1'b1 : 1'b0;
        end
      3'b010           :
        begin             //XOR
         {alu_out, NN, VV}  =   {alu_in1  ^  alu_in2,   2'b00};
          ZZ                =   (alu_out ==  16'h0000) ? 1'b1  : 1'b0;
        end
      3'b011           :
        begin             //RED
         {alu_out, NN, VV, ZZ}  =   {RED,     3'b000};
        end
      3'b111           :
        begin             //PADDSB
          alu_out           =    PADDSB;
         {NN, ZZ, VV}       =    3'b000;
        end
      default          :
        begin             //Shift
         {alu_out, NN, VV}  =   {Shift,       2'b00};
          ZZ                =   (alu_out ==  16'h0000) ? 1'b1  : 1'b0;
        end
    endcase
  end

  //flag register
  wire    NVen,  Zen;
  assign  NVen =  &(~Opcode[3:1]),
          Zen  =    ~Opcode[3] & ~(&Opcode[1:0]);

  dff     Nff          (.q(N),  .d(NN),  .wen(NVen), .clk(clk), .rst(rst)),
          Zff          (.q(Z),  .d(ZZ),  .wen(Zen),  .clk(clk), .rst(rst)),
          Vff          (.q(V),  .d(VV),  .wen(NVen), .clk(clk), .rst(rst));

endmodule
