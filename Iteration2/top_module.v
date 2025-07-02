module top_module(
    input clk,
    input reset
    );

    // this is the top module of the project it connects all the modules together creating a single data flow path between 
    // different modules
    // first lets start with PC 

    wire [31:0] pc_next,pc;
    pc inst1( .clk(clk), .reset(reset), .pc_next(pc_next) , .pc(pc));
    
    // pc then goes to instruction fetch memory , which outputs a 32 bit instruction

    wire [31:0] instruction;
    instr_mem inst( .byte_address(pc), .instruction(instruction));
    
    // now this instruction is broken into smaller vectors and processed in different modules, lets start with reg_file

    wire [31:0] data, read_data1, read_data2;
    wire [4:0] reg_mux;
    wire [31:0] write_to_reg_data;
    wire regWrite;
    Register_file rf_inst(.clk(clk), .Read_reg1(instruction[25:21]), .Read_reg2(instruction[20:16]), .Write_reg(reg_mux), .Data(write_to_reg_data),
                        .Read_data1(read_data1), .Read_data2(read_data2), .RegWrite(regWrite));

    // now for reg_mux  is output from mux which decides where the destination reg is
    
    wire regDst;
    mux_5bit mux1(.in1(instruction[20:16]), .in2(instruction[15:11]), .sel(regDst), .out(reg_mux));	

    // now lets call the sign extender
    
    wire [31:0] extnded_sgnl;
    sign_extend sig1(.to_extend(instruction[15:0]),.extended(extnded_sgnl));

    // now for alu control
    
    wire [1:0] aluop;
    wire [3:0] alu_in;
    alu_control alu_ctrl_inst(.aluop(aluop), .funct(instruction[5:0]) , .result(alu_in));

    // now let's connect AlU
    
    wire [31:0] alu_result;
    wire zero;
    alu alu_inst(.ctrl(alu_in) , .in1(read_data1), .in2(alusrc_mux) , .result(alu_result), .zero(zero));

    // for  alusrc_mux we need 32 bit mux result
    
    wire [31:0] alusrc_mux;
    wire alusrc;	
    mux_32bit mux2(.in1(read_data2), .in2(extnded_sgnl), .sel(alusrc), .out(alusrc_mux));


    //Now let's connect the data memory
    
    wire memRead, memWrite;
    wire [31:0] mem_output;
    data_memory dm_inst(.address(alu_result), .write_data(read_data2), .mem_read(memRead), .mem_write(memWrite), .clock(clk) , .read_data(mem_output));

    //Now let's finish up this path with write_to_reg_data mux 32 bit
    
    wire memToReg;		  
    mux_32bit mux3(.in1(alu_result), .in2(mem_output) , .sel(memToReg) ,.out(write_to_reg_data));

    // now connecting the control unit
    
    wire branch;
    control_unit ctrl_inst(.opcode(instruction[31:26]), .regDst(regDst), .branch(branch) , .memRead(memRead),.memToReg(memToReg), .aluop(aluop), .memWrite(memWrite), .alusrc(alusrc), .regWrite(regWrite));

    // for PC update branch or branch not path
    
    wire [31:0] pc_branch;
    wire [31:0] update_pc;
    wire [31:0] word_extended_sgnl; // word extended is just left shifted by2

    shift_left ss1( .in( extnded_sgnl),.out(word_extended_sgnl));

    // normal +4 next instruction update path

    adder_32bit nobranch(.in1(pc) ,.in2(4) ,.out(update_pc));

    // branch taken, remembr that branch is with respect to next instruction so in1=pc+4=update_pc
    
    adder_32bit tobranch(.in1(update_pc) , .in2(word_extended_sgnl), .out(pc_branch));

    // now to choose whether or not to branch we need 32 bit mux
    
    wire branch_and_zero;
    assign branch_and_zero= branch && zero;
    mux_32bit mux4(.in1(update_pc), .in2(pc_branch) , .sel(branch_and_zero), .out(pc_next));
    
    // this completes the data paths

endmodule
