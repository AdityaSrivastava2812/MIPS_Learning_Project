module iter3(input clk,
             input reset);

    // Here we define the top module and connect all the separate components.

    // Defining the control unit.
    wire [5:0] opcode; // Input for control unit.
    wire regDst, branch, memRead, memToReg, memWrite, alusrc, regWrite;
	wire [1:0] aluop;
    control_unit control_unit_inst(.opcode(opcode), .regDst(regDst), .branch(branch), .memRead(memRead), .memToReg(memToReg), 
                                   .aluop(aluop), .memWrite(memWrite), .alusrc(alusrc), .regWrite(regWrite));

    // Defining wires for sending control signals to pipeline register.
    wire [8:0] ctrl_mux_out;
    wire id_ex_control; // A control signal from the hazard detection unit.
    mux_9bit ctrl_select(.in1({regWrite, memToReg, branch, memRead, memWrite, regDst, aluop, alusrc}),
                         .in2(9'd0), .sel(id_ex_control), .out(ctrl_mux_out));

    // Defining the connections for the instruction fetch (IF) stage.
    
    // Connections for program counter.
    wire pcsrc; // To control the address of next instruction.
    assign pcsrc = mem_zero & mem_mem_con[2]; // Control signals coming from MEM stage.
    mux_32bit pc_select(.in1(pc_4), .in2(mem_pc_4_off), .sel(pcsrc), .out(pc_next));
    wire [31:0] pc_next, pc;
    wire freeze_pc;
    pc pc_inst(.clk(clk), .reset(reset), .pc_next(pc_next), .pc(pc));

    // Connections for instruction memory.
    wire [31:0] instruction;
    instr_mem instr_mem_inst(.byte_address(pc), .instruction(instruction));

    // Defining the IF/ID pipeline register.
    wire [63:0] if_id_in;
    wire freeze_if_id; // A control signal from the hazard detection unit.
    wire [4:0] id_rs, id_rt, id_rd; // Naming as <nextStage>_<register>.
    wire [15:0] imm; // For any immediate values.
    wire [31:0] pc_4, id_pc_4; // To store PC + 4 and the second vector is to carry it along the pipeline.
	assign if_id_in = {pc_4, instruction};
    adder_32bit pc_plus_4(.in1(pc), .in2(32'd4), .out(pc_4));
    if_id_reg if_id_inst(.reg_in(if_id_in), .clk(clk), .freeze(freeze_if_id), .if_id_instr({opcode, id_rs, id_rt, imm}),
                         .if_id_pc_4(id_pc_4));
    assign id_rd = imm[15:11]; // Getting the value of rd.

    wire [31:0] ext_imm; // Sign extended immediate value from 16 bits to 32 bits.
    sign_extend sign_extend_inst(.to_extend(imm), .extended(ext_imm));

    // Defining the connections for the instruction decode (ID) stage.

    // Defining the register file.
    wire [31:0] Data, Read_data1, Read_data2; // Data and final_reg_dst will be set using signals from forwarding unit.
    Register_file reg_file_inst(.clk(clk), .Read_reg1(id_rs), .Read_reg2(id_rt), .Write_reg(wb_rd), 
                                .Data(Data), .Read_data1(Read_data1), .Read_data2(Read_data2), .RegWrite(wb_wr_con[1]));

    // Defining the ID/EX pipeline register.
    wire [151:0] id_ex_in;
    assign id_ex_in = {ctrl_mux_out, id_pc_4, Read_data1,
                       Read_data2, ext_imm, id_rs, id_rt, id_rd};
    wire [4:0] ex_rs, ex_rt, ex_rd;
	wire [31:0] ex_ext, ex_data1, ex_data2, ex_pc_4;
	wire [3:0] ex_ex_con;
	wire [2:0] ex_mem_con;
	wire [1:0] ex_wr_con;
    id_ex_reg id_ex_inst(.clk(clk), .reg_in(id_ex_in), .id_ex_rs(ex_rs), .id_ex_rt(ex_rt), .id_ex_rd(ex_rd), .id_ex_ext(ex_ext),
                         .id_ex_data1(ex_data1), .id_ex_data2(ex_data2), .id_ex_pc_4(ex_pc_4), .id_ex_ex_con(ex_ex_con), 
                         .id_ex_mem_con(ex_mem_con), .id_ex_wr_con(ex_wr_con));

    // Defining the connections for the execution (EX) stage.
    
    // Defining ALU inputs.
    wire [31:0] alu_in1, regValue, alu_in2;
    mux_to_alu muxA(.mux_control(muxA_control), .in_0(ex_data1), .in_1(mem_alu_res), .in_2(Data), .out(alu_in1));
    mux_to_alu muxB(.mux_control(muxB_control), .in_0(ex_data2), .in_1(mem_alu_res), .in_2(Data), .out(regValue));
    mux_32bit reg_or_imm(.in1(regValue), .in2(ex_ext), .sel(ex_ex_con[0]), .out(alu_in2));

    // Defining the ALU.
    wire [3:0] aluctrl;
    wire [31:0] alu_result;
    wire zero;
    alu alu_inst(.ctrl(aluctrl), .in1(alu_in1), .in2(alu_in2), .result(alu_result), .zero(zero));

    // Defining ALU Control.
    alu_control alu_control_inst(.aluop(ex_ex_con[2:1]), .funct(ex_ext[5:0]), .result(aluctrl));

    // Calculating next address.
    wire [31:0] left_shifted_ext, pc_branch;
    shift_left shift_left_inst(.in(ex_ext), .out(left_shifted_ext));
    adder_32bit pc_plus_4_plus_imm(.in1(ex_pc_4), .in2(left_shifted_ext), .out(pc_branch));

    // Picking between ex_rt and ex_rd.
    wire [4:0] rd_out;
    mux_5bit rt_or_rd(.in1(ex_rt), .in2(ex_rd), .sel(ex_ex_con[3]), .out(rd_out));

    // Defining the EX/MEM register.
    wire [106:0] ex_mem_in;
    assign ex_mem_in = {ex_wr_con, ex_mem_con, pc_branch, zero, alu_result, alu_in2, rd_out};
    wire [4:0] mem_rd;
	wire [31:0] mem_read_data2, mem_alu_res, mem_pc_4_off;
	wire mem_zero;
	wire [2:0] mem_mem_con;
	wire [1:0] mem_wr_con;
    ex_mem_reg ex_mem_inst(.clk(clk), .reg_in(ex_mem_in), .ex_mem_data2(mem_read_data2), .ex_mem_rd(mem_rd), 
                           .ex_mem_alu_res(mem_alu_res), .ex_mem_zero(mem_zero), .ex_mem_pc_4_off(mem_pc_4_off), 
                           .ex_mem_mem_con(mem_mem_con), .ex_mem_wr_con(mem_wr_con));

    // Defining the connections for the memory (MEM) stage.

    // Defining data memory.
    wire [31:0] data_from_mem;
    data_memory data_memory_inst(.address(mem_alu_res), .write_data(mem_read_data2), .clock(clk),
                                 .read_data(data_from_mem), .mem_read(mem_mem_con[1]), .mem_write(mem_mem_con[0]));

    // Defining MEM/WB register.
    wire [70:0] mem_wb_in;
    assign mem_wb_in = {mem_wr_con, data_from_mem, mem_alu_res, mem_rd};
    wire [4:0] wb_rd;
	wire [31:0] wb_alu_res, wb_read_data;
	wire [1:0] wb_wr_con;
    mem_wb_reg mem_wb_inst(.clk(clk), .reg_in(mem_wb_in), .mem_wb_rd(wb_rd), .mem_wb_alu_res(wb_alu_res), .mem_wb_wr_con(wb_wr_con),
                           .mem_wb_read_data(wb_read_data));

    // Defining the write back (WB) stage.
    mux_32bit write_back_mux(.in1(wb_alu_res), .in2(wb_read_data), .sel(wb_wr_con[0]), .out(Data));

    // Defining the forwarding unit.
    wire [1:0] muxA_control, muxB_control;
    forwarding_unit forwarding_unit_inst(.ex_mem_reg_write(mem_wr_con[1]), .mem_wb_reg_write(wb_wr_con[1]), .id_ex_rt(ex_rt),
                                         .id_ex_rs(ex_rs), .ex_mem_rd(mem_rd), .mem_wb_rd(wb_rd), .muxA_control(muxA_control),
                                         .muxB_control(muxB_control));

    // Defining the hazard detection unit.
    hazard_dete hazard_dete_inst(.id_ex_mem_read(mem_mem_con[1]), .id_ex_rt(ex_rt), .if_id_rs(id_rs), .if_id_rt(id_rt),
                                 .id_ex_control(id_ex_control), .if_id_write(freeze_if_id), .pc_write(freeze_pc));


endmodule