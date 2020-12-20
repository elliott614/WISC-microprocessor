module hazard_detection ( id_ex_memread, id_ex_registerRt, if_id_registerRs, if_id_registerRd, if_id_registerRt, id_ex_opcode, stall);
  
input id_ex_memread;
input [3:0] id_ex_registerRt;
input [3:0] if_id_registerRt;
input [3:0] if_id_registerRs;  
input [3:0] if_id_registerRd;
input [3:0] id_ex_opcode;
output stall;


//need to stall when load instruction is followed by a read of the same register
//id_ex_memread checks for load instruction
//then check if the instruction after it is reading from that register

//wire check1, check2;
//assign check1 = (id_ex_registerRt == if_id_registerRs);
//assign check2 = (id_ex_registerRt == if_id_registerRt);

// don't stall if 2nd instruction is sw. mem-to-mem fw does this.
assign stall = ((id_ex_opcode != 4'b1001) & id_ex_memread & ((id_ex_registerRt == if_id_registerRs) | (id_ex_registerRt == if_id_registerRt))) ;

/*
assign stall 	= id_ex_registerRt != 4'bz ? 1'b1
		: id_ex_registerRt != 4'bz ? 1'b1
		: id_ex_registerRt != 4'bz ? 1'b1
		: id_ex_registerRt != 4'bz ? 1'b0
		: id_ex_registerRt != 4'bz ? 1'b0
	*/	


endmodule
