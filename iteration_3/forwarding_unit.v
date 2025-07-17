module Forwarding_unit(
    input ex_mem_reg_write,
    input mem_wb_reg_write,
    input [4:0] id_ex_rt,
    input [4:0] id_ex_rs,
    input [4:0] ex_mem_rd,
    input [4:0] mem_wb_rd,
    output reg [1:0] muxA_control,
    output reg [1:0] muxB_control
    );
// refer to Forwarding unit doc for Documentation.
// As discussed in details in Forwarding unit doc help, MIPS structure is throughlly followed in
// this module. we will generate 6 control signals for controlling 2 muxes.

// for mux A control
always @(*) begin
if ( (ex_mem_reg_write && (ex_mem_rd != 0) && (id_ex_rs==ex_mem_rd))) begin
		muxA_control= 2'b10; end
else if (mem_wb_reg_write && (mem_wb_rd != 0) &&
        !(ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs)) &&
        (mem_wb_rd == id_ex_rs))
begin muxA_control= 2'b01;end
else muxA_control= 2'b00;
end

// now for mux B control 
always @(*) begin
if ( (ex_mem_reg_write && (ex_mem_rd != 0) && (id_ex_rt==ex_mem_rd))) begin
		muxB_control= 2'b10; end
else if (mem_wb_reg_write && (mem_wb_rd != 0) &&
                 !(ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rt)) &&
                 (mem_wb_rd == id_ex_rt))
begin muxB_control= 2'b01;end
else muxB_control= 2'b00;
end

endmodule



