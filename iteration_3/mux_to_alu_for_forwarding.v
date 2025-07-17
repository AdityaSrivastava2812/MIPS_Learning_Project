module mux_to_alu(
    input [1:0] mux_control,
    input [31:0] in_0,
    input [31:0] in_1,
    input [31:0] in_2,
    output reg [31:0] out
    );
always @(*) begin
if (mux_control==2'b00) out = in_0;
else if (mux_control==2'b01) out = in_1;
else if (mux_control==2'b10) out = in_2;
else out = out; end
endmodule