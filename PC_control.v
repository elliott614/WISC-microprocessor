module PC_control(input  [15:0] ID_instr,  ID_pc, br_addr, input [2:0] F, input [15:0] IF_pc_in,
                  output [15:0] IF_pc_out, input halt, output inval_out, input inval_in);

//IF_pc_in  = current value of PC in fetch stage
//IF_pc_out = next value of PC, input to IF/ID block
//ID_pc     = PC in ID stage (output from IF/ID block)
//ID_instr  = Instruction currently in ID stage
//br_addr   = address from register in BR instruction
//F         = flags
//halt      = halt? obviously

//in case of branch, should be able to just stall pipeline until F and (if BR) br_addr inputs are valid

  wire   Cout1, Cout2, Z, V, N, BR, B;
  wire   [15:0] PCplus2, AddShiftRes, ID_pc_plus2;
  reg    BranchEn;
  wire   [2:0] C;
  wire   [8:0] I;
  wire   [3:0] Opcode;

  assign C      = ID_instr[11:9];
  assign I      = ID_instr[8:0];
  assign Opcode = ID_instr[15:12];

  assign {Z, V, N} =  F;

 assign  IF_pc_out = halt ? IF_pc_in
		   : inval_in ? PCplus2
		   : (BranchEn & BR) ? br_addr 	
		   : (BranchEn & B)  ? AddShiftRes
		   :  PCplus2;

  assign  B        = (Opcode == 4'b1100);
  assign  BR       = (Opcode == 4'b1101);

//we will never have 2 invalids in a row
  assign inval_out = inval_in ? 1'b0 : (BranchEn & (B | BR));

  add_16bit_lookahead plus2       ( .Sum(PCplus2),   .C16(Cout1), .A(IF_pc_in), .B(16'h0002),             .C0(1'b0) ),
 		      add2 ( .Sum(ID_pc_plus2),   .C16(Cout1), .A(ID_pc), .B(16'h0002),             .C0(1'b0) ),
                      branchAdder ( .Sum(AddShiftRes), .C16(Cout2), .A(ID_pc_plus2),    .B({{6{I[8]}}, I, 1'b0}), .C0(1'b0) );

  always @ (C, F)
  begin
    case (C)
      3'b000  : BranchEn =   ~Z;       //NEQ
      3'b001  : BranchEn =    Z;       //EQ
      3'b010  : BranchEn =  ~(Z  | N); //GT
      3'b011  : BranchEn =    N;       //LT
      3'b100  : BranchEn =   ~N;       //GTEQ
      3'b101  : BranchEn =    Z  | N;  //LTEQ
      3'b110  : BranchEn =    V;       //Ovfl
      default : BranchEn = 1'b1;       //Always
    endcase
  end

endmodule
