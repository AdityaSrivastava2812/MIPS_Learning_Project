module mux_9bit(input [8:0] in1,
				input [8:0] in2,
				input sel,
				output reg [8:0] out);
					  
	always @ (*) begin
	
		case(sel)	
			1'b0 : out = in1;
			1'b1 : out = in2;		
		endcase
		
	end
					  
endmodule