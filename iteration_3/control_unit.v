module control_unit(input [5:0] opcode,
					output reg regDst,
					output reg branch,
					output reg memRead,
					output reg memToReg,
					output reg [1:0] aluop,
					output reg memWrite,
					output reg alusrc,
					output reg regWrite);
						  
	reg [8:0] total_control;
						  
	always @ (*) begin
	
		case (opcode)
		
			6'b000000 : total_control = {1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1}; // R-format instructions.
			6'b100011 : total_control = {1'b0, 1'b0, 1'b1, 1'b1, 2'b00, 1'b0, 1'b1, 1'b1}; // load word
			6'b101011 : total_control = {1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1, 1'b1, 1'b0}; // store word
			6'b000100 : total_control = {1'b0, 1'b1, 1'b0, 1'b0, 2'b01, 1'b0, 1'b0, 1'b0}; // branch if equal
			default : total_control = 9'b0; // Do nothing
		
		endcase
		
		{regDst, branch, memRead, memToReg, aluop[1:0], memWrite, alusrc, regWrite} = total_control;
	
	end
						  
endmodule						  