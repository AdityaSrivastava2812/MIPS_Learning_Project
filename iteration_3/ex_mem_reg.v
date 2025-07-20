module ex_mem_reg(input [106:0] reg_in,
				  input clk,
				  output reg [31:0] ex_mem_data2,
				  output reg [4:0] ex_mem_rd,
				  output reg [31:0] ex_mem_alu_res,
				  output reg ex_mem_zero,
				  output reg [31:0] ex_mem_pc_4_off,
				  output reg [2:0] ex_mem_mem_con,
				  output reg [1:0] ex_mem_wr_con);
						
	always @ (posedge clk) begin
	
		ex_mem_wr_con <= reg_in[106:105]; // 2 bits
		ex_mem_mem_con <= reg_in[104:102]; // 3 bits
		ex_mem_pc_4_off <= reg_in[101:70]; // 32 bits
		ex_mem_zero = reg_in[69]; // 1 bit
		ex_mem_alu_res <= reg_in[68:37]; // 32 bits
		ex_mem_data2 <= reg_in[36:5]; // 32 bits
		ex_mem_rd <= reg_in[4:0]; // 5 bits
	
	end
						
endmodule