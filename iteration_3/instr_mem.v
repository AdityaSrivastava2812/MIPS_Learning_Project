
module instr_mem(
    input [31:0] byte_address ,
    output reg [31:0] instruction
);
// This is the Instruction Memory ideally it can provide 2^32 words but we have decided to stick to 256 words for now,
// also This module is completely asynchronous at least for our first iteration, so it basically gives whatever instruction is stored at given address
// This is ROM hence no write operation
// address provides byte location , for example address 3 is 3rd byte , we only give word access in instruction because for MIPS all instructions are 32 bits
// so all byte address that are given as an input must be divisible by 4, i.e 0,4,8,12,16.....1024
// Note- 1024 byte address is actually 255th word (last, for now)

  reg [31:0] memory [0:255];
always @(*) begin
 if(byte_address<1024) begin
	if(byte_address[1:0]==2'b00) begin // checks divisibility by 4
 	instruction = memory[byte_address[31:2]]; // convert byte to memory address 
			             end
	 else begin
		instruction = 0; end // firstly we left this condition unattended but synthesis tool gave unattended latch warning
// We assume for now that instruction 0 is like NOP in 8086
             end		
else  begin instruction = 0; end // meaning adress is 1024, for now again we have not decided so NOP

       	    end

endmodule
