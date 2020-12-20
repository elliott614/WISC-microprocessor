module ID_EX (             output [15:0] rdata1_out, rdata2_out, signextend_out, EX_instr, EX_pc,// data from register 1, register 2, s.e.imm
			   output        EX_memread, EX_regwrite, EX_memtoreg, EX_memwrite, EX_alusrc, EX_inval,
			   output [3:0]  EX_regtowrite,
			   output [3:0]  ID_EX_Rs, ID_EX_Rt,
			   input  [3:0]  ID_regtowrite,
			   input  [15:0] rdata1_in,  rdata2_in,  signextend_in, ID_instr, ID_pc,
			   input  [3:0]	 IF_ID_Rs, IF_ID_Rt,
			   //input  [1:0]	 controlMux, // controlMux | controlMux[0] : MemRead, controlMux[1] : RegWrite
			  
			   input 		ID_memread, ID_regwrite, ID_alusrc, ID_memtoreg, ID_memwrite, ID_inval,
			   input 		 wen, clk, rst );
  

  dff inval   [15:0] (.q(EX_inval), .d(ID_inval), .wen(wen), .clk(clk), .rst(rst));
  dff rdata1     [15:0] (.q(rdata1_out),     .d(rdata1_in),     .wen(wen), .clk(clk), .rst(rst));
  dff rdata2     [15:0] (.q(rdata2_out),     .d(rdata2_in),     .wen(wen), .clk(clk), .rst(rst));
  dff signextend [15:0] (.q(signextend_out), .d(signextend_in), .wen(wen), .clk(clk), .rst(rst));
  dff instr      [15:0] (.q(EX_instr),       .d(ID_instr),      .wen(wen), .clk(clk), .rst(rst));
  dff pc         [15:0] (.q(EX_pc),          .d(ID_pc),         .wen(wen), .clk(clk), .rst(rst));
  
  dff Rs		 [3:0]  (.q(ID_EX_Rs),		 .d(IF_ID_Rs),		.wen(wen), .clk(clk), .rst(rst));
  dff Rt		 [3:0]  (.q(ID_EX_Rt),		 .d(IF_ID_Rt),		.wen(wen), .clk(clk), .rst(rst));
  //dff Rd		 [3:0]  (.q(ID_EX_Rd),		 .d(IF_ID_Rd),		.wen(wen), .clk(clk), .rst(rst));
  
  dff MemRead	        (.q(EX_memread),    .d(ID_memread),    .wen(wen), .clk(clk), .rst(rst));
  dff RegWrite	        (.q(EX_regwrite),   .d(ID_regwrite),   .wen(wen), .clk(clk), .rst(rst));
  dff Memwrite	        (.q(EX_memwrite),   .d(ID_memwrite),   .wen(wen), .clk(clk), .rst(rst));
  dff alusrc	        (.q(EX_alusrc),     .d(ID_alusrc),     .wen(wen), .clk(clk), .rst(rst));
  dff memtoreg	        (.q(EX_memtoreg),   .d(ID_memtoreg),   .wen(wen), .clk(clk), .rst(rst));

  dff regtowrite [3:0]  (.q(EX_regtowrite), .d(ID_regtowrite), .wen(wen), .clk(clk), .rst(rst));

endmodule