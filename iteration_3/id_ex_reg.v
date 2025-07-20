module id_ex_reg(input [151:0] reg_in,
				 input clk,
				 output reg [4:0] id_ex_rs,
  				 output reg [4:0] id_ex_rt,
				 output reg [4:0] id_ex_rd,
				 output reg [31:0] id_ex_ext,
				 output reg [31:0] id_ex_data1,
				 output reg [31:0] id_ex_data2,
				 output reg [31:0] id_ex_pc_4,
				 output reg [3:0] id_ex_ex_con,
				 output reg [2:0] id_ex_mem_con,
				 output reg [1:0] id_ex_wr_con);
	
	always @ (posedge clk) begin
	
		id_ex_wr_con <= reg_in[151:150]; // 2 bits
		id_ex_mem_con <= reg_in[149:147]; // 3 bits
		id_ex_ex_con <= reg_in[146:143]; // 4 bits
		id_ex_pc_4 <= reg_in[142:111]; // 32 bits
		id_ex_data1 <= reg_in[110:79]; // 32 bits
		id_ex_data2 <= reg_in[78:47]; // 32 bits
		id_ex_ext <= reg_in[46:15]; // 32 bits
		id_ex_rs <= reg_in[14:10]; // 5 bits
		id_ex_rt <= reg_in[9:5]; // 5 bits
		id_ex_rd <= reg_in[4:0]; // 5 bits
	
	end

endmodule