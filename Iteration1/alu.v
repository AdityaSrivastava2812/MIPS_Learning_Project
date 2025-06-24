module alu (input [3:0] ctrl,
	    input [31:0] in1,
	    input [31:0] in2,
	    output reg [31:0] result,
	    output reg zero);
				
	always @ (*) begin
	
		zero = 0;
		
		case (ctrl)
			4'b0000 : result = in1 & in2; // AND
			4'b0001 : result = in1 | in2; // OR
			4'b0010 : result = in1 + in2; // addition
			4'b0110 : result = in1 - in2; // subtraction
			4'b0111 : result = (in1 < in2) ? 1 : 0; // set on less than
			4'b1100 : result = ~(in1 | in2); // NOR
			default : result = 0;
		endcase
		
		if (result == 0) zero = 1; // zero flag
	
	end
				
endmodule
