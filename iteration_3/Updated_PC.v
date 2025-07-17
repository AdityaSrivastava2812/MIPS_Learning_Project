module pc(
    input clk,
    input reset,
    input freeze,               // newly added input , will be used by Hazard unit 
    input [31:0] pc_next,
    output reg [31:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else if (!freeze)       // Only update when not freeze
            pc <= pc_next;
        // if freeze==1 it will not update , as required .
    end
endmodule
