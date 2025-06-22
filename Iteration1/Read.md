# Iteration-1
In the first iteration, we will implement a single-cycle 32-bit RISC processor in Verilog. Special care will be taken to ensure that the complete module is directly synthesizable for software.


For this iteration, we will consider 3 types of instructions-
-The arithmetic-logical instructions add, sub, AND, OR, and slt (set if less than).
-The memory-reference instructions load word (lw) and store word (sw).
-The instructions for branch (beq).

The instructions format is same as that of MIPS-




We will create various modules to implement the processor and link them together in the top module  at the end. We will create modules for the following components,

**Register file:** The set of 32-bit general-purpose registers. Can be read or written. On a read, it takes two inputs for the number of each register, and gives the values stored in the registers at its two outputs. The write data signal must be enabled, and the data to be written must be provided for a write instruction along with the register to be written.

**Arithmetic Logic Unit (ALU):** Takes in two 32-bit words as input and provides the output of the desired arithmetic/logical operation, depending on the ALU control signals from the control unit. Also has a zero flag, which is set to high if the result of the computation is a zero. The inputs can come in either from two registers or one register and an immediate value.

**Instruction Memory:** The memory unit to hold the instructions of the program. Takes in the instruction address at its input and outputs the requested instruction as a 32-bit word, which is sent to the required components.
Data Memory: The memory unit that holds the data needed for the proper execution of the program. Since the same data bus can’t be used in a single-cycle processor, the program and data are stored in separate memories.

**Program Counter (PC):** Will hold the address of the next instruction that needs to be fetched from instruction memory. It is updated via a network of adders and multiplexers to determine whether the next instruction is to be fetched or a branch is to be taken. 

**Control unit:** It will take opcode and function fields as input and generate control signals like RegWrite, ALUSrc, MemWrite, MemRead, Branch, ALUOp, etc. which will decide the Datapath. 




The complete data path will look like-



(credits for image to opensource and RISC)
