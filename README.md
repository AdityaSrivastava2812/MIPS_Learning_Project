# MIPS Processor Implementation Project

# Overview

This repository aims to implement and document the making of a MIPS architecture.  
This is a learning project, hence we will keep updating it as we learn new things and grow.

**Contributors:** **Aditya**(https://github.com/AdityaSrivastava2812) and  **Yug**(https://github.com/llYuGll)  
We welcome contributions, so please feel free to submit a pull request.

We promise to commit ourselves to the development of this project. It will not only include the implementation but also proper documentation of our learnings and mistakes. We will not remove any of our previous versions of the project and will keep iterating it to the optimal level.

For starters, we will implement the basic RISC architecture as given in the *Computer Organisation and Design* book by Hennessy. (Single clock) 
We will also add RTL synthesis and other details as we make progress.
```
Update [23 July, 2025]:
It’s been two months since we began working on this project. In our first iteration, we implemented a single-cycle MIPS processor. While the initial version had several bugs and was not synthesizable, we debugged the design and made Iteration 2 fully synthesizable, with no logical errors.
After that, we moved to a 5-stage pipelined, multi-cycle MIPS architecture, incorporating both forwarding and hazard detection units, in iteration 3. We’re currently in the process of adding support for additional instructions before moving on to the next phase.
```

**Repository structure**
```
RISC_sys/
├── Iteration_Docs
├── Iteration1, Iteration2...
            ├──All the modules in this iteration(ALU,REG FILE , Read me etc) 
├──Images
├──Synthesis (contains RTL view and other files)
└── README.md (for overall projects) 
```
**NOTE**
Each Iteration file contains all the required modules and a top module connecting them all. Additionally Iteration 3 folder also contains a combined file containing all the modules. 

**Next Steps:**  
Begin with the single-cycle implementation under iteration 1, then proceed to synthesis and pipelining.
```
Update [23 July, 2025]:
We have completed 5-stage pipelining. Before moving to the next iteration (4), we will first add some more instructions in the design. Also we will add RTL view files for iterations 2 and 3, along with the yosys synthesis bugs we received and improved upon.
```

