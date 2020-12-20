module PC (PC_out, PC_in, clk, rst);
	
	input 	[15:0]	  PC_in;
	input		  clk,      rst;
	
	output	[15:0]	  PC_out;
	
	dff DFF[15:0] (.q(PC_out), .d(PC_in), .wen(16'hffff), .clk(clk), .rst(rst));

endmodule
