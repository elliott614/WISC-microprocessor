module forwarding_unit ( output [1:0] muxASel, muxBSel, output muxCSel,
						 input  [3:0] EX_MEM_Rd, MEM_WB_Rd, ID_EX_Rs, ID_EX_Rt,
						 input		  EX_MEM_RegWrite, MEM_WB_RegWrite );
	
	// muxASel, muxBSel | 00: No Forwarding, 10: EX-to-EX forwarding, 01: MEM-to-EX forwarding
        // muxCSel: 0: no mem-to-mem forwarding, 1: mem-to-mem forwarding

	assign muxASel = (ID_EX_Rs == 4'b00) 						  ? 2'b00 :
					 (EX_MEM_RegWrite & (EX_MEM_Rd == ID_EX_Rs))  ? 2'b10 :
					 ((MEM_WB_RegWrite & (MEM_WB_Rd == ID_EX_Rs)) ? 2'b01 : 2'b00) ;
	
	assign muxBSel = (ID_EX_Rt == 4'b00) 						  ? 2'b00 :
					 (EX_MEM_RegWrite & (EX_MEM_Rd == ID_EX_Rt))  ? 2'b10 :
					 ((MEM_WB_RegWrite & (MEM_WB_Rd == ID_EX_Rt)) ? 2'b01 : 2'b00) ;
    
	assign muxCSel = (MEM_WB_RegWrite & (EX_MEM_Rd != 4'b0) & (EX_MEM_Rd == MEM_WB_Rd));

endmodule
