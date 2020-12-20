module instruction_memory (clk, rst_n, pcCurrent, instruction);

  input         clk, rst_n;
  input  [15:0] pcCurrent;
  output [15:0] instruction;

  memory1c mem(
	.data_out(instruction), 
	.data_in(16'h0), 
	.addr(pcCurrent), 
	.enable(1'b1), 
	.wr(1'b0), 
	.clk(clk),
        .rst(~rst_n)
  );


endmodule
