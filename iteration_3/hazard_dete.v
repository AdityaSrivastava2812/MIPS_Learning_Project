module Hazard_dete_unit(
    input id_ex_mem_read,
    input [4:0] id_ex_rt,
    input [4:0] if_id_rs,
    input [4:0] if_id_rt,
    output reg id_ex_control,
    output reg if_id_write,
    output reg pc_write
		);
// The code explaination and working are documented in hazard docs, please refer
// for detecting the stall the condition is that load word should be followed by i type instruction that demands same register that is being loaded in lw 
always @(*) begin
if (id_ex_mem_read && (( id_ex_rt== if_id_rs) || ( id_ex_rt== if_id_rt)) ) begin
	id_ex_control=0; pc_write=0; if_id_write=0; end
else id_ex_control=1; pc_write=1; if_id_write=1; end

endmodule
