module EX_MEM ( output [15:0] aluresult_out, MEM_alusrc2, MEM_instr,
		output 	      MEM_RegWrite, MEM_MemRead, MEM_memtoreg, MEM_memwrite, MEM_inval,
                output	[3:0] MEM_regtowrite,
		input	[3:0] EX_regtowrite,
		input  [15:0] aluresult_in, EX_alusrc2, EX_instr,
		input	      EX_RegWrite, EX_MemRead, EX_memtoreg, EX_memwrite, EX_inval,
                input         wen, clk, rst );

  dff inval   [15:0] (.q(MEM_inval), .d(EX_inval), .wen(wen), .clk(clk), .rst(rst));
  dff aluresult [15:0] (.q(aluresult_out),   .d(aluresult_in),   .wen(wen), .clk(clk), .rst(rst));
  dff alusrc2	[15:0] (.q(MEM_alusrc2),     .d(EX_alusrc2),	 .wen(wen), .clk(clk), .rst(rst));
  dff instr 	[15:0] (.q(MEM_instr),       .d(EX_instr),	 .wen(wen), .clk(clk), .rst(rst));
  dff MemRead	       (.q(MEM_MemRead),     .d(EX_MemRead),     .wen(wen), .clk(clk), .rst(rst));	 
  dff RegWrite	       (.q(MEM_RegWrite),    .d(EX_RegWrite),    .wen(wen), .clk(clk), .rst(rst));
  dff memwrite	       (.q(MEM_memwrite),    .d(EX_memwrite),    .wen(wen), .clk(clk), .rst(rst));		
  dff memtoreg	       (.q(MEM_memtoreg),    .d(EX_memtoreg),    .wen(wen), .clk(clk), .rst(rst));
  dff reg2write [3:0] (.q(MEM_regtowrite),  .d(EX_regtowrite),  .wen(wen), .clk(clk), .rst(rst));
endmodule
