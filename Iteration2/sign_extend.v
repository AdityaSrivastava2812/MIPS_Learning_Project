module sign_extend(
    input [15:0] to_extend,
    output [31:0] extended
    );
assign extended = {{16{to_extend[15]}}, to_extend};

endmodule

