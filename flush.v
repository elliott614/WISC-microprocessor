/*
------------------------- flush logic block ----------------------------------
id_instruction = branch instruction from ID stage.
register1_value = value from register 1 after it is read in ID stage.
register2_value = value from register 2 after it is read in ID stage.
take_branch = decision of whether or not branch will be taken or not.  This is also the flush signal.
*/

module flush (clk, rst_n, id_instruction, register1_value, register2_value, take_branch);

input [15:0] id_instruction;
input register1_value;
input register2_value;
input clk;
input rst_n;
output take_branch;

reg flush;
wire zflag,vflag,nflag,alu_out;

//only assert take branch if the instruction is a branch instructnion
assign take_branch = (id_instruction[15:12] == 4'b1100) | (id_instruction[15:12] == 4'b1101) ? flush : 1'b0;

ALU predictor (                         
	.alu_out(), 
	.Z(zflag), 
	.V(vflag),
	.N(nflag),
	.alu_in1(register1_value), 
	.alu_in2(register2_value),  
	.Opcode(id_instruction[15:12]),
        .clk(clk),
        .rst(~rst_n)
   );

always @ (*) begin
    	case(id_instruction[11:9])
	3'b000:
        begin	//not equal
		flush = (zflag == 1'b0);
	end
	3'b001:
        begin	//equal
		flush = zflag;
	end
	3'b010:
        begin	//greather than
		flush = (zflag == nflag) & (zflag == 1'b0);
	end
	3'b011:
        begin	//less than
		flush = (nflag == 1'b1);
	end
	3'b100:
        begin	//greater than or equal
		flush = (zflag == 1'b1) | (zflag == nflag) & (zflag == 1'b0);
	end
	3'b101:
        begin	//less than or equal
		flush = (nflag == 1'b1) | (zflag == 1'b1);
	end
	3'b110:
        begin	//overflow
		flush = vflag;
	end
	3'b111:
        begin	//unconditional
		flush = 1'b1;
	end
	default:
	begin
		flush = 1'b0;
	end
	endcase
end

endmodule
