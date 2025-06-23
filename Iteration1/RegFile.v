module Register_file(
    input clk,
    input [4:0] Read_reg1,
    input [4:0] Read_reg2,
    input [4:0] Write_reg,
    input [31:0] Data,
    output reg [31:0] Read_data1,
    output reg [31:0] Read_data2,
    input RegWrite
    );
// as explained in our Read.md Reg file will hold all the registers
// here MIPS has 32 general purpose registers all 32 bit wide, one of them is hard grounded to zero
// we will stick with Conventional numbering and naming of MIPS architecture
// hence reg [31:0] registers [31:0] have to explicitly written, so please bear
reg [31:0] zero, at, v0, v1, a0, a1, a2, a3, t0, t1, t2, t3, t4, t5, t6, t7, s0, s1, s2, s3, s4, s5, s6, s7, t8, t9, k0, k1, gp, sp, fp, ra;
// we will also try and stick to the conventional usage of register as in MIPS
initial zero=0; // hard wired to gnd
// The read operation is completely assynchronus and doesnt depend on any other input
always @(*) begin// its lenghty but we have decided to follow MIPS naming
//so read_data1/2 will always have some value, and when their is any change in read_reg it will update or else hold on previous value
 case(Read_reg1)
  5'd0: Read_data1= zero;
  5'd1: Read_data1=at;
  5'd2: Read_data1=v0;
  5'd3: Read_data1=v1;
  5'd4: Read_data1=a0;
  5'd5: Read_data1=a1;
  5'd6: Read_data1=a2;
  5'd7: Read_data1=a3;
  5'd8: Read_data1=t0;
  5'd9: Read_data1=t1;
  5'd10: Read_data1=t2;
  5'd11: Read_data1=t3;
  5'd12: Read_data1=t4;
  5'd13: Read_data1=t5;
  5'd14: Read_data1=t6;
  5'd15: Read_data1=t7;
  5'd16: Read_data1=s0;
  5'd17: Read_data1=s1;
  5'd18: Read_data1=s2;
  5'd19: Read_data1=s3;
  5'd20: Read_data1=s4;
  5'd21: Read_data1=s5;
  5'd22: Read_data1=s6;
  5'd23: Read_data1=s7;
  5'd24: Read_data1=t8;
  5'd25: Read_data1=t9;
  5'd26: Read_data1=k0;
  5'd27: Read_data1=k1;
  5'd28: Read_data1=gp;
  5'd29: Read_data1=sp;
  5'd30: Read_data1=fp;
  5'd31: Read_data1=ra;
  endcase
  case(Read_reg2)
   5'd0: Read_data2= zero;
  5'd1: Read_data2=at;
  5'd2: Read_data2=v0;
  5'd3: Read_data2=v1;
  5'd4: Read_data2=a0;
  5'd5: Read_data2=a1;
  5'd6: Read_data2=a2;
  5'd7: Read_data2=a3;
  5'd8: Read_data2=t0;
  5'd9: Read_data2=t1;
  5'd10: Read_data2=t2;
  5'd11: Read_data2=t3;
  5'd12: Read_data2=t4;
  5'd13: Read_data2=t5;
  5'd14: Read_data2=t6;
  5'd15: Read_data2=t7;
  5'd16: Read_data2=s0;
  5'd17: Read_data2=s1;
  5'd18: Read_data2=s2;
  5'd19: Read_data2=s3;
  5'd20: Read_data2=s4;
  5'd21: Read_data2=s5;
  5'd22: Read_data2=s6;
  5'd23: Read_data2=s7;
  5'd24: Read_data2=t8;
  5'd25: Read_data2=t9;
  5'd26: Read_data2=k0;
  5'd27: Read_data2=k1;
  5'd28: Read_data2=gp;
  5'd29: Read_data2=sp;
  5'd30: Read_data2=fp;
  5'd31: Read_data2=ra;
  endcase
end
// the write operation is clocked, and functions only if both clock edge arrives and RegWrite is asserted
always@(posedge clk)
if(RegWrite) begin
case(Write_reg)
  5'd0: zero<=Data;
  5'd1: at<=Data;
  5'd2: v0<=Data;
  5'd3: v1<=Data;
  5'd4: a0<=Data;
  5'd5: a1<=Data;
  5'd6: a2<=Data;
  5'd7: a3<=Data;
  5'd8: t0<=Data;
  5'd9: t1<=Data;
  5'd10: t2<=Data;
  5'd11: t3<=Data;
  5'd12: t4<=Data;
  5'd13: t5<=Data;
  5'd14: t6<=Data;
  5'd15: t7<=Data;
  5'd16: s0<=Data;
  5'd17: s1<=Data;
  5'd18: s2<=Data;
  5'd19: s3<=Data;
  5'd20: s4<=Data;
  5'd21: s5<=Data;
  5'd22: s6<=Data;
  5'd23: s7<=Data;
  5'd24: t8<=Data;
  5'd25: t9<=Data;
  5'd26: k0<=Data;
  5'd27: k1<=Data;
  5'd28: gp<=Data;
  5'd29: sp<=Data;
  5'd30: fp<=Data;
  5'd31: ra<=Data;
  endcase 
  end
endmodule
----------
