This document explains about the Forwarding unit and Hazard detection unit being implemented in the pipelined MIPS processor for iteration 3. For now the Control hazards are not being addressed.

**Forwarding Unit Logic**

A) Ex/mem Register to ID/Ex register 

This is needed in a situation where a register being updated in the 1st instruction is needed to be used as an operand in the following instructions.
For Example-
```
 add $1,$2,$3;// opcode-rd-rs-rt
 and $3,$1,$4;
```
so $1 being the destination register in instruction 1 is used again in instruction 2 as an operand. This is a problem for pipelined processor. The 1st instruction will be able to update the $1 register only in the 1st half of 5th clock cycle (Write Back), but 2nd instruction will demand the same register in the 4th clock cycle, so clearly it will read the not updated value of $1, if forwarding logic is not defined. 
Ex/mem--->ID/Ex forwarding logic uses the fact that the result of 1st instruction can directly be taken from ALU output to be used as operand of the ALU for the next instruction.

When to forward? if (register number of destination reg in EX-mem reg == register number of operand registers in ID-EX reg) that is if  EX-mem_rd==ID_ex_(rs or rt)
But also this can create a problem if the instruction doesn't actually write in the destination register and at the same time we also need to make sure that the rd is not $0, because in that case there is no need of forwarding, because $0 is hard ground to zero so by forwarding  it will actually produce wrong input for the next instruction. 
say for example-
```
add $0,$2,$3;// opcode-rd-rs-rt
and $3,$0,$4;
```
so if forwarded $3=(($2+$3)+$4) but in reality it should have been $3=($4+$0)=$4.
so considering for these two extra conditions the new forwarding logic becomes - Forward if ( EX-mem_rd==ID_ex_(rs or rt) && ( EX-mem_rd != 0 ) && ( EX-mem_write_reg)) 

B) mem/wb Register to ID/Ex register 

This is required where a register being updated in the 1st instruction is needed again to be used as an operand in 3rd instruction.
example-
```
add $1,$2,$3;// opcode-rd-rs-rt
and $3,$5,$4;
or  $5,$0,$1;
```
This  sequence of instructions can also cause error because the 1st instruction will update the $1 register  in the first half of 5th clock cycle, but the 3rd instruction will also need it as an operand to the ALU in the 5th clock cycle itself. Hence once again forwarding can solve this problem by providing bypass from Mem/wb register to id/ex register.
so mem/wb--->ID/Ex forward if ( mem_wb_rd==ID_ex_(rs or rt) && ( mem_wb_rd != 0 ) && ( mem_wb_write_reg)) 
But it still has some problem.
considering following example.
```
add $1,$2,$3;// opcode-rd-rs-rt -inst1
and $1,$5,$4;                   -inst2
or  $5,$0,$1;                   -inst3
```
Here $1 is being updated in 1st as well as 2nd instruction but the 3rd instruction needs it as an operand in the 5th clock cycle , but the forwarding logic should make sure that the most recently updated value is given, that is from ALU result of instruction 2. Hence for the 3rd instruction although both Ex/mem_rd  mem/wb_rd matches with the operand , the forwarding should be done from Ex/mem as it has the most recently updated value.


therefore the complete logic for mem/wb--->ID/Ex forward is- if  ( mem_wb_rd==ID_ex_(rs or rt) && ( mem_wb_rd != 0 ) && ( mem_wb_write_reg) && EX-mem_rd==ID_ex_(rs or rt) && ~( EX-mem_rd != 0 ) && ( EX-mem_write_reg)) 
Basically we just gave Ex/mem--->ID/Ex higher priority.

For now this is the complete logic behind forwarding unit controlling muxA and muxB which decide what value is used as ALU operand.
*Any other change in forwarding logic will be updated here.



**Hazard detection**

It is required because some hazards can not be solved by forwarding alone. More specifically for our used I,R,J type instruction set , Load followed by i type instruction that demands for the 'being loaded' reg in load instruction as an operand can not be solved by forwarding. Why?
Consider the example-
```
lw $1,4($2); // $1= rt and $2=rs
add $4, $1,$3; //opcode-rd-rs-rt
```
Here the 2nd instruction will need $1 reg as an input in 4th clock cycle, but the updating of value of $1 will be done in 5th cycle. At the same time unlike previous cases there is no other way of getting the updated value. So stall is the only option. Also the hazard unit is present ID stage so that we can insert stall before the hazard actually occurs in EX stage.
Like previous cases we will again make sure that it is lw instruction by checking for id_ex_read_memory signal.
logic for stalling =
stall if ( id_ex_read_memory && ((id_ex_rt== if_id_rs) || ( id_ex_rt== if_id_rt)))
By stalling we are actually inserting a NOP instruction in a cycle which will pass through every stage as any other normal instructions. At the same time it is needed to make sure that PC and IF stage do not update to new values, hence we need to freeze them. (NOP will only travel from EX to WB) 
Inserting 0 for all control signal (specifically Mem read and reg write) can act as NOP. 
For freezing of PC and IF stage we have updated PC and IF/ID reg modules to repeat previous state if stall detected by hazard unit.


This documents the complete logic of forwarding and Hazard unit that we are using in our pipelined design in iteration 3. 



