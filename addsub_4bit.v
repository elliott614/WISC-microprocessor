module addsub_4bit (Sum, Ovfl, A, B, sub);
	// Module represents a 4 bit adder/subtractor that is composed of 4 1 bit full adders

	// Initialization
	input [3:0] 	A, B; 				// Input values
	input 			sub; 				// Add-sub indicator (Mode Select Bit) [0 is addition, 1 is subtraction)

	output [3:0] 	Sum; 				// Sum output
	output 			Ovfl; 				// Indicates overflow

	wire [3:0] 		BP;					// Wire containing the mode appropriate values of B
	wire 			FAW1, FAW2, FAW3; 	// Wires connecting the 4 full adders
	wire			Cout;				// Wire containing the carry out

	// Sum Logic
	assign	BP = B ^ {4{sub}};	// XOR B with mode select (Negates when sub = 1; Othewise B passes through) 

	full_adder_1bit FA0 (.S(Sum[0]), .COut(FAW1), .A(A[0]), .B(BP[0]), .CIn(sub));	// Full Adder bit 0

	full_adder_1bit FA1 (.S(Sum[1]), .COut(FAW2), .A(A[1]), .B(BP[1]), .CIn(FAW1)); // Full Adder bit 1

	full_adder_1bit FA2 (.S(Sum[2]), .COut(FAW3), .A(A[2]), .B(BP[2]), .CIn(FAW2)); // Full Adder bit 2

	full_adder_1bit FA3 (.S(Sum[3]), .COut(Cout), .A(A[3]), .B(BP[3]), .CIn(FAW3)); // Full Adder bit 3

	// Overflow Logic
	assign 	Ovfl = Cout ^ FAW3;	// Sets overflow bit for signed operation
								// For unsigned set FA3 Cout to OVFL and comment out this assignment
								
endmodule