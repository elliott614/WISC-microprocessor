module cpu ( clk, rst_n, hlt, pc_out );

	input        	clk, rst_n;
	output       	hlt;
	output [15:0]	pc_out;

	wire   [15:0] 	IF_instruction, ID_instruction, EX_instruction, MEM_instruction, WB_instruction;

	wire   [15:0] 	ID_alu_in1,  ID_alu_in2, ID_signextend, ID_pc_reg_out, 
					EX_alu_in1,  EX_alu_in2, EX_alu_out, EX_pc,  
					MEM_memdata, MEM_datain,
					WB_output_value, 
					pc_reg_in, pc_reg_out;	

	wire          	zflag, vflag, nflag,
					PCS;          //PCS instruction?

				
	wire 	[15:0] 	MuxAOut, MuxBOut;

	wire 	[1:0] 	MuxASel, MuxBSel;
	wire 			MuxCSel;

	wire 	[3:0] 	WB_regtowrite;            
	wire 	[3:0] 	ID_regtowrite, readreg1, readreg2;
  
	wire          	ID_regwrite,    ID_alusrc,    ID_memwrite,   ID_memtoreg,   ID_memread, ID_loadbyte;
	wire 	[15:0] 	WB_aluresult;
	wire 	[15:0] 	WB_memdata;
	wire 			WB_regwrite; 
	wire 			WB_memtoreg;
	wire 			MEM_memread, MEM_regwrite, MEM_memtoreg, MEM_memwrite;
	wire 	[15:0] 	MEM_alusrc2, MEM_alu_out;
	wire 	[3:0] 	MEM_regtowrite;  
	wire 			EX_regwrite, EX_memtoreg;
	wire 	[15:0] 	rdata1_out, rdata2_out, EX_signextend;
	wire 	[3:0] 	EX_regtowrite, EX_Rs, EX_Rt;
	wire 			stall,flop_enable, EX_memread;
  
	wire IF_inval, ID_inval, EX_inval, MEM_inval, WB_inval;


	assign hlt         = (&WB_instruction[15:12]) & ~WB_inval;
	assign pc_out      = pc_reg_out;
	assign flop_enable = ~stall;

	PC_control pc_control (
		.halt(hlt),
		.ID_instr(ID_instruction),
		.br_addr(ID_alu_in1),
		.F({zflag,vflag,nflag}),  //F[2:0] = {Z,V,N}
		.ID_pc(ID_pc_reg_out),
		.IF_pc_in(pc_reg_out),
		.IF_pc_out(pc_reg_in),
		.inval_out(IF_inval),
		.inval_in(ID_inval)
	);

	hazard_detection hdetection ( 
		.id_ex_memread(EX_memread), 
		.id_ex_registerRt(EX_instruction[3:0]), 
		.if_id_registerRs(ID_instruction[7:4]), 
		.if_id_registerRd(ID_instruction[11:8]),  
		.if_id_registerRt(ID_instruction[3:0]),
		.id_ex_opcode(ID_instruction[15:12]),
		.stall(stall)
	);

	forwarding_unit f_u ( .muxASel(MuxASel), 
		.muxBSel(MuxBSel), 
		.muxCSel(MuxCSel),
		.EX_MEM_Rd(MEM_regtowrite), 
		.MEM_WB_Rd(WB_regtowrite), 
		.ID_EX_Rs(EX_Rs), 
		.ID_EX_Rt(EX_Rt),
		.EX_MEM_RegWrite(MEM_regwrite), 
		.MEM_WB_RegWrite(WB_regwrite)
	);

//=============================================
//PIPELINE START
//=============================================
//IF

	PC pc_register(
		.PC_out(pc_reg_out), 
		.PC_in(pc_reg_in), 
		.clk(clk), 
		.rst(~rst_n)
	);

  	instruction_memory fetch0 (
		.clk(clk), 
		.rst_n(rst_n), 
		.pcCurrent(pc_reg_out), //from PC module
		.instruction(IF_instruction)
	);

//IF
//=============================================
//IF/ID

	IF_ID if_id (
		.pc_in(pc_reg_out),
		.pc_out(ID_pc_reg_out),
		.IF_instr(IF_instruction),
		.ID_instr(ID_instruction),
		.wen(flop_enable),
		.clk(clk),
		.rst(~rst_n),
		.IF_inval(IF_inval),
		.ID_inval(ID_inval)
  	);

//IF/ID
//=============================================
//ID

	assign readreg1 = ID_instruction[7:4];
	assign readreg2 = ID_memwrite | ID_loadbyte ? ID_instruction[11:8] : ID_instruction[3:0];
	assign ID_regtowrite = ID_instruction[11:8];
	assign llb = (WB_instruction[15:12] == 4'ha);
	assign lhb = (WB_instruction[15:12] == 4'hb);
	assign ID_signextend = {{12{ID_instruction[3]}}, ID_instruction[3:0]};

    control_signals cs (  //branch control handled inside PC_control
		.instruction(ID_instruction),   
		.memread(ID_memread),
		.memtoreg(ID_memtoreg),  
		.memwrite(ID_memwrite), 
		.alusrc(ID_alusrc), 
		.regwrite(ID_regwrite),
		.loadbyte(ID_loadbyte)
	);
	//need to change regwrite
	//need to change output_value

	RegisterFile rf (
		.clk(clk),
		.rst(~rst_n),
		.SrcReg1(readreg1), //register1 to read from
		.SrcReg2(readreg2), //register2 to read from
		.DstReg(WB_regtowrite),	    //register to write to
		.WriteReg(WB_regwrite),	    //control signal
		.DstData(WB_output_value),	    //data to write
		.SrcData1(ID_alu_in1),	    //data read from reg 1
		.SrcData2(ID_alu_in2)	    //data read form reg 2
  	);

//ID
//=============================================
//ID/EX

	ID_EX id_ex (
		.ID_alusrc(ID_alusrc),  //control signal, 1 bit
		.ID_pc(ID_pc_reg_out),
		.rdata1_in(ID_alu_in1),  
		.rdata2_in(ID_alu_in2),
		.signextend_in(ID_signextend), 
		.ID_instr(ID_instruction),	//Instruction word contains opcode/rs/rt
		.wen(1'b1), // since IF/ID deasserts wen, previous instruction preserved during stall
		.clk(clk), 
		.rst(~rst_n),
		.EX_alusrc(EX_alusrc),
		.EX_pc(EX_pc),
		.EX_instr(EX_instruction), 
		.rdata1_out(rdata1_out),
		.rdata2_out(rdata2_out), 
		.signextend_out(EX_signextend), 
		.ID_memread(ID_memread), 
		.ID_regwrite((stall | ID_inval)? 1'b0 : ID_regwrite), //insert no-op here
		.ID_memwrite((stall | ID_inval)? 1'b0 : ID_memwrite),
		.EX_memread(EX_memread),
		.EX_memwrite(EX_memwrite),
		.EX_regwrite(EX_regwrite),
		.ID_regtowrite(ID_regtowrite),
		.EX_regtowrite(EX_regtowrite),
		.ID_memtoreg(ID_memtoreg),
		.EX_memtoreg(EX_memtoreg),
		.ID_EX_Rs(EX_Rs),
		.ID_EX_Rt(EX_Rt),
		.IF_ID_Rs(readreg1),
		.IF_ID_Rt(readreg2),
		.ID_inval(ID_inval),
		.EX_inval(EX_inval)
	);

//ID/EX
//=============================================
//EX
	
	assign EX_alu_in1 = EX_instruction[15:13] == 3'b101 ? 	{8'h00,EX_instruction[7:0]} : rdata1_out;

	assign EX_alu_in2 = EX_alusrc ?	EX_signextend : MuxBOut;

	assign PCS = (&EX_instruction[15:13]) & ~EX_instruction[12];

	Mux3to1_16bit muxa ( 
						.out(MuxAOut),
						.in0(EX_alu_in1), //no forwarding
						.in1(WB_output_value), //mem-to-ex
						.in2(MEM_alu_out), //ex-to-ex
						.sel(MuxASel)
					   );

	Mux3to1_16bit muxb ( 
						.out(MuxBOut),
						.in0(rdata2_out), //no forwarding
						.in1(WB_output_value), //mem-to-ex
						.in2(MEM_alu_out), //ex-to-ex
						.sel(MuxBSel)
						);

	ALU_top aluTop (                         //flag register is inside ALU module
		.inval(EX_inval),
		.alu_out(EX_alu_out), 
		.Z(zflag), 
		.V(vflag),
		.N(nflag),
		.alu_in1(MuxAOut), 
		.alu_in2(EX_alu_in2),  
		.Opcode(EX_instruction[15:12]),
		.clk(clk),
		.rst(~rst_n)
	);

wire [15:0] EX_pc_plus2;
add_16bit_lookahead add2 ( .Sum(EX_pc_plus2), .A(EX_pc), .B(16'h0002), .C0(1'b0) );


//EX
//=============================================
//EX/MEM

	EX_MEM ex_mem (
		.aluresult_out(MEM_alu_out), 
		.MEM_RegWrite(MEM_regwrite),
		.MEM_MemRead(MEM_memread),
		.MEM_memwrite(MEM_memwrite),
		.MEM_alusrc2(MEM_alusrc2),
		.MEM_instr(MEM_instruction),
		.MEM_regtowrite(MEM_regtowrite),
		.MEM_memtoreg(MEM_memtoreg),
		.aluresult_in(PCS ? EX_pc_plus2 : EX_alu_out),
		.EX_regtowrite(EX_regtowrite),
		.EX_memtoreg(EX_memtoreg),
		.EX_memwrite(EX_memwrite),
		.EX_RegWrite(EX_regwrite),
		.EX_MemRead(EX_memread),
		.EX_alusrc2(rdata2_out),
		.EX_instr(EX_instruction),
		.wen(1'b1),  // Always 1. Insert no-op here by changing control signals when stalling
		.clk(clk), 
		.rst(~rst_n),
		.EX_inval(EX_inval),
		.MEM_inval(MEM_inval)
	  );

//EX/MEM
//=============================================
//MEM

	Mux2to1_16bit muxc ( 
		.out(MEM_datain), 
		.in0(MEM_alusrc2), 
		.in1(WB_memdata), 
		.sel(MuxCSel) 
	);

	memory1c data_memory (
		.data_out(MEM_memdata), 
		.data_in(MEM_datain), 
		.addr(MEM_alu_out), 
		.enable(MEM_memwrite | MEM_memread), 
		.wr(MEM_memwrite & ~MEM_memread), 
		.clk(clk), 
		.rst(~rst_n)
	);


//MEM
//=============================================
//MEM/WB

	MEM_WB mem_wb (
		.WB_memdata(WB_memdata),
		.WB_memtoreg(WB_memtoreg), 
		.WB_aluresult(WB_aluresult),
		.WB_RegWrite(WB_regwrite),
		.WB_instr(WB_instruction),
		.WB_regtowrite(WB_regtowrite),
		.MEM_memdata(MEM_memdata),  
		.MEM_memtoreg(MEM_memtoreg),
		.MEM_aluresult(MEM_alu_out), 
		.MEM_regtowrite(MEM_regtowrite),
		.MEM_RegWrite(MEM_regwrite),
		.MEM_instr(MEM_instruction),
		.wen(1'b1), 
		.clk(clk), 
		.rst(~rst_n),
		.MEM_inval(MEM_inval),
		.WB_inval(WB_inval)
	);

//MEM/WB
//=============================================
//WB


	
	assign WB_output_value 	=  WB_memtoreg ? WB_memdata : 
											 WB_aluresult; //PC register is in WB_aluresult

endmodule
