module MEM_WB ( output [15:0] WB_memdata, WB_aluresult, WB_instr,
		output 	      WB_RegWrite, WB_memtoreg, WB_inval,
		output [3:0]  WB_regtowrite,
		input  [15:0] MEM_memdata,  MEM_aluresult, MEM_instr,
		input	      MEM_RegWrite, MEM_memtoreg, MEM_inval,
		input  [3:0] MEM_regtowrite,
		input 	      wen, clk, rst );


  dff inval   [15:0] (.q(WB_inval), .d(MEM_inval), .wen(wen), .clk(clk), .rst(rst));
  dff memdata   [15:0] (.q(WB_memdata),     .d(MEM_memdata),      .wen(wen), .clk(clk), .rst(rst));
  dff aluresult [15:0] (.q(WB_aluresult),   .d(MEM_aluresult),    .wen(wen), .clk(clk), .rst(rst));
  dff instr     [15:0] (.q(WB_instr),       .d(MEM_instr),        .wen(wen), .clk(clk), .rst(rst));
  dff RegWrite	       (.q(WB_RegWrite), .d(MEM_RegWrite), .wen(wen), .clk(clk), .rst(rst));	
  dff memtoreg	       (.q(WB_memtoreg), .d(MEM_memtoreg), .wen(wen), .clk(clk), .rst(rst));	
  dff reg2wr    [3:0]  (.q(WB_regtowrite), .d(MEM_regtowrite), .wen(wen), .clk(clk), .rst(rst));

endmodule
