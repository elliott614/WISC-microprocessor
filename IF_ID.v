module IF_ID ( output [15:0] pc_out, output [15:0] ID_instr, input [15:0] pc_in,
                input [15:0] IF_instr, input wen, input clk, input rst, input IF_inval, output ID_inval );

  dff pc       [15:0] (.q(pc_out),   .d(pc_in),    .wen(wen), .clk(clk), .rst(rst));
  dff instr    [15:0] (.q(ID_instr), .d(IF_instr), .wen(wen), .clk(clk), .rst(rst));
  dff inval   [15:0] (.q(ID_inval), .d(IF_inval), .wen(wen), .clk(clk), .rst(rst));

endmodule
