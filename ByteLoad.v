module ByteLoad(in, loadByte, high, out);

    input	[15:0] 	in;
    input	[7:0] 	loadByte;	// byte to be loaded
    input 			high;
	
    output[15:0] 	out;

    assign out = high ? {loadByte, in[7:0]} : {in[15:8], loadByte};
	
endmodule