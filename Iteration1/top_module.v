module top_module(
    input clk,
    input reset
    );
// this is the top module of the project it connects all the modules together creating a single data flow path between 
// different modules
// first lets start with PC updatation

wire [31:0] pc_next,pc;
pc inst( .clk(clk), .reset(reset), pc_next(pc_next) , .pc(pc));
// pc_next then goes to instruction fetch memory , which outputs a 32 bit instruction

wire [31:0] instruction;
inst_mem inst( .byte_address(pc_next), .instruction(instruction));
//now this instruction is broken into smaller vectors and processed in different modules, lets start with reg_file
wire [31:0] data, read_data1, read_data2;
wire [4:0] reg_mux;
wire [31:0] write_to_reg_data;
wire regWrite;
register_file inst( .clk(clk), read_reg1(instruction[25:21]), .read_reg2(instruction[20:16]), .write_reg(reg_mux),.data(write_to_reg_data),.read_data1(read_data1),.read_data2(read_data2), .Regwrite(regWrite));
// okay now before i forget about this wires lets create a mux for reg_mux
wire regDst;
assign reg_mux=regDst? instruction[15:11]:instruction[20:16] ;
// now lets create a sign_extender
 wire [31:0] extnded_sgnl;
 assign extnded_sgnl = {{16{instruction[15]}}, instruction[15:0]};
// now for alu control
wire [1:0] aluop;
wire [3:0] alu_in;
alu_control inst(.aluop(aluop) , .func(instruction[5:0]) , .result(alu_in));
// now lets connect AlU
wire [31:0] alu_result;
wire zero;
alu inst( .ctrl(alu_in) , .in1(read_data1) ,.in2(alusrc_mux) , .result(alu_result), .zero(zero));
// now again lets finish up with alusrc_mux before forgetting it
wire [31:0] alusrc_mux;
wire alusrc;
assign alusrc_mux = alusrc? extnded_sgnl : read_data2 ;

// now lets connect the data memory
wire memRead, memWrite;
wire [31:0] mem_output;
data_memory inst( .address(alu_result) , .write_data(read_data2) , .mem_read(memRead) ,.mem_write(memWrite) ,.clock(clk) , read_data(mem_output));
// now lets finish up this path with write_to_reg_data mux
wire memToreg;
assign write_to_reg_data = memToreg? mem_output: alu_result;

// now connecting control unit
wire branch;
control_unit inst( .opcode( instruction[31:26]), .regDst(regDst), .branch(branch) ,.memRead(memRead),.memToreg(memToreg) ,.aluop(aluop),.memWrite(memWrite), .alusrc(alusrc), .regWrite(regWrite));
// now the final path for PC jump update
wire [31:0] pc_branch;
wire [31:0] update_pc;
wire [31:0] word_extended_sgnl;
assign word_extended_sgnl= extnded_sgnl<<2;
assign update_pc = (pc_next+4) ;
assign pc_branch= update_pc + word_extnded_sgnl;
// now to choose what goes to pc
assign pc = ( branch && zero )? pc_branch:update_branch;
//This completes the datapath.




endmodule

