module alu_control(input [1:0] aluop,
		   input [5:0] funct,
		   output reg [3:0] result);

	wire [7:0] ctrl_in = {aluop, funct};
	
	always @ (*) begin
	
		// These cases follow the MIPS instruction set. We shall
		// add more instructions in further iterations.
		casez (ctrl_in)
		
			8'b00?????? : result = 4'b0010; // addition
			8'b01?????? : result = 4'b0110; // subtraction
			8'b10100000 : result = 4'b0010; // addition
			8'b10100010 : result = 4'b0110; // subtraction
			8'b10100100 : result = 4'b0000; // AND
			8'b10100101 : result = 4'b0001; // OR
			8'b10101010 : result = 4'b0111; // set on less than
			8'b10100111 : result = 4'b1100; // NOR
			default : result = 4'b1111; // Do nothing
		
		endcase
		
	end
						 
endmodule
