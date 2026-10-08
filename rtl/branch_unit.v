module branch_unit (
    input         Branch,
    input         Jump,
    input         Zero,

    input  [15:0] pc,
    input  [15:0] offset,

    output [15:0] next_pc
);

wire [15:0] sequential_pc;
wire [15:0] branch_pc;
wire [15:0] jump_pc;

assign sequential_pc = pc + 16'd1;

assign branch_pc = pc + offset;

assign jump_pc = pc + offset;

assign next_pc =
       Jump ? jump_pc :
       (Branch && Zero) ? branch_pc :
       sequential_pc;

endmodule