module control_signals (instruction, memread,  memtoreg, memwrite, alusrc, regwrite);

input [15:0] instruction; 
output       memread,   memtoreg,    memwrite, alusrc,   regwrite;

             //high if LW		
assign       memread = (instruction[15:12] == 4'h8),

             //high if LW
             memtoreg = memread,

             //high if SW 
             memwrite = (instruction[15:12] == 4'h9),

             //high if using immediate (aka not compute instruction) or SW/LW
             alusrc = memread | memwrite | instruction[14] & (~instruction[13] | ~instruction[12]),

             //high if not sw, hlt, br, b
             regwrite = ~((instruction[15:12] == 4'h9) | (instruction[15:12] == 4'hf) | (instruction[15:12] == 4'hC) | (instruction[15:12] == 4'hD));

endmodule
