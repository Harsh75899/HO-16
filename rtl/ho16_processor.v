module ho16_processor (
    input clk,
    input reset,
    output [15:0] pc,
    output [15:0] instruction,
    output [15:0] next_pc
);

wire [15:0] BranchOffset;

wire Branch;
wire Zero;
wire Jump;


// ------------------------------------
// FETCH UNIT
// ------------------------------------

fetch_unit fetch (
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),

    .pc(pc),
    .instruction(instruction)
);


// ------------------------------------
// CPU CORE
// ------------------------------------
cpu core (
    .clk(clk),
    .instruction(instruction),

    .Branch(Branch),
    .Jump(Jump),
    .Zero(Zero),
    .BranchOffset(BranchOffset)
);

// ------------------------------------
// BRANCH UNIT
// ------------------------------------

branch_unit branch (
    .Branch(Branch),
    .Jump(Jump),
    .Zero(Zero),

    .pc(pc),
    .offset(BranchOffset),

    .next_pc(next_pc)
);

endmodule