module cpu ( clk, rst_n, hlt, pc );

  input         clk, rst_n;
  output        hlt;
  output [15:0] pc;

  wire   [15:0] initial_PC,  instruction,  alu_in1,    alu_in2,     register2, alu_out, mem_out,
                         output_value, pc_reg_in,  pc_reg_out,  signextend;	
  wire   [3:0]  writereg, readreg1, readreg2;
  wire          regwrite,    alusrc,       memwrite,   memtoreg,    memread,   aluop,
                zflag, vflag, nflag,
                PCS,          //PCS instruction?
                halt,         //HALT instruction?
                llb, lhb;     //LLB or LHB instruction?

  assign        signextend   = {{12{instruction[3]}},      instruction[3:0]},
                alu_in2      =      alusrc ? signextend :  register2,
                PCS          =    (&instruction[15:13]) & ~instruction[12],
                halt         =     hlt ? hlt : &instruction[15:12],
                pc           =      pc_reg_out,
                llb          =     (instruction[15:12] == 4'ha),
                lhb          =     (instruction[15:12] == 4'hb),
                writereg     =      instruction[11:8],
                output_value =      PCS       ? pc_reg_in             :
                                    llb | lhb ? {2{instruction[7:0]}} :
                                    memtoreg  ? mem_out               :
                                    alu_out,
                readreg1     =      instruction[7:4],
                readreg2     =      memwrite ?     instruction[11:8]  : instruction[3:0];



  dff halt_ff (         //send hlt signal on next rising edge (maybe unnecessary on single-cycle processor)
        .q(hlt),
        .d(halt),
        .wen(1'b1),
        .clk(clk),
        .rst(~rst_n)
   );

  control_signals cs (  //branch control handled inside PC_control
	.instruction(instruction),   
	.memread(memread),
	.memtoreg(memtoreg),  
	.memwrite(memwrite), 
	.alusrc(alusrc), 
	.regwrite(regwrite)
   );

  intruction_memory fetch0 (
	.clk(clk), 
	.rst_n(rst_n), 
	.pcCurrent(pc_reg_out), //from PC module
	.instruction(instruction)
   );

  PC pc_register(
	.PC_out(pc_reg_out), 
	.PC_in(pc_reg_in), 
	.clk(clk), 
	.rst(~rst_n)
	
   );

  PC_control pc_control (
	.C(instruction[11:9]),
	.I(instruction[8:0]),
        .aluin1(alu_in1),
        .Opcode(instruction[15:12]),
	.F({zflag,vflag,nflag}),  //F[2:0] = {Z,V,N}
	.PC_in(pc_reg_out),
	.PC_out(pc_reg_in),
	.halt(hlt)
   );

  RegisterFile rf (
	.clk(clk),
	.rst(~rst_n),
	.SrcReg1(readreg1), //register1 to read from
	.SrcReg2(readreg2), //register2 to read from
	.DstReg(writereg),	    //register to write to
	.WriteReg(regwrite),	    //control signal
	.DstData(output_value),	    //data to write
	.SrcData1(alu_in1),	    //data read from reg 1
	.SrcData2(register2),	    //data read form reg 2
        .llb(llb),                  //only write low byte?
        .lhb(lhb)                   //only write high byte?
   );

  ALU alu (                         //flag register is inside ALU module
	.alu_out(alu_out), 
	.Z(zflag), 
	.V(vflag),
	.N(nflag),
	.alu_in1(alu_in1), 
	.alu_in2(alu_in2),  
	.Opcode(instruction[15:12]),
        .clk(clk),
        .rst(~rst_n)
   );

  memory1c data_memory (
	.data_out(mem_out), 
	.data_in(register2), 
	.addr(alu_out), 
	.enable(memwrite | memread), 
	.wr(memwrite & ~memread), 
	.clk(clk), 
	.rst(~rst_n)
   );

endmodule
