module mem_wb_reg(input [70:0] reg_in,
				  input clk,
				  output reg [4:0] mem_wb_rd,
				  output reg [31:0] mem_wb_alu_res,
				  output reg [31:0] mem_wb_read_data,
				  output reg [1:0] mem_wb_wr_con);
						
	always @ (posedge clk) begin
	
		mem_wb_wr_con <= reg_in[70:69]; // 2 bits
		mem_wb_read_data <= reg_in[68:37]; // 32 bits
		mem_wb_alu_res <= reg_in[36:5]; // 32 bits
		mem_wb_rd <= reg_in[4:0]; // 5 bits
	
	end
						
endmodule