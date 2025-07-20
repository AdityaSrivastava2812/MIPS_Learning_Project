module if_id_reg(input [63:0] reg_in,
				 input clk,
				 input freeze,
				 output reg [31:0] if_id_instr,
				 output reg [31:0] if_id_pc_4);
	
	always @ (posedge clk) begin

		if (!freeze) begin
		
			if_id_pc_4 <= reg_in[63:32];
			if_id_instr <= reg_in[31:0];
			
		end
		
	end
	
endmodule