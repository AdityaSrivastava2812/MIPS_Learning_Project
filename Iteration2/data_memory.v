module data_memory(input [31:0] address,
						 input [31:0] write_data,
						 input mem_read,
						 input mem_write,
						 input clock,
						 output reg [31:0] read_data);
	
	reg [7:0] memory [0:(1 << 10) - 1]; // 1 KB memory.
	wire [31:0] addr = {address[31:2], 2'b00}; // Forces word alignment.
						 
	always @ (*) begin
	
		if (mem_read & ~(mem_write)) read_data = {memory[address], memory[address + 1],
																memory[address + 2], memory[address + 3]};
	
	end
	
	always @ (posedge clock) begin
	
		if (mem_write & ~(mem_read)) begin
			
			memory[address] <= write_data[31:24];
			memory[address + 1] <= write_data[23:16];
			memory[address + 2] <= write_data[15:8];
			memory[address + 3] <= write_data[7:0];
			
		end
		
	end
						 
endmodule