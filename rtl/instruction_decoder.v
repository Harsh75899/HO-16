module instruction_decoder (
    input  [15:0] instruction,

    output [3:0] opcode,
    output [2:0] rd,
    output [2:0] rs1,
    output [2:0] rs2,
    output [5:0] immediate
);

assign opcode    = instruction[15:12];
assign rd        = instruction[11:9];
assign rs1       = instruction[8:6];
assign rs2       = instruction[5:3];
assign immediate = instruction[5:0];

endmodule