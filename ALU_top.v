module ALU_top  ( alu_out, Z, V, N, alu_in1, alu_in2, Opcode, clk, rst, inval );
	
	output	[15:0]  alu_out;
	output			Z,     V,    N;                //flag register outputs
	input  	[15:0]  alu_in1,     alu_in2;
	input   [3:0]   Opcode;
	input           clk, inval,   rst;
	
	wire	[15:0]	alu_res, byte_res;
	
	ALU alu(  
			.alu_out(alu_res),
			.Z(Z),     .V(V),    .N(N),        
			.alu_in1(alu_in1),     .alu_in2(alu_in2),
			.Opcode(Opcode),
			.clk(clk),   .rst(rst) ,.inval(inval)
			);
	
	ByteLoad bite(
					.in(alu_in2),
					.loadByte(alu_in1[7:0]),
					.high(Opcode[0]),
					.out(byte_res)
					);
	
	assign alu_out = (Opcode[3:1] == 3'b101) ? byte_res : alu_res;
	
endmodule