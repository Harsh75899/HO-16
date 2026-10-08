module fetch_unit (
    input         clk,
    input         reset,
    input  [15:0] next_pc,

    output [15:0] pc,
    output [15:0] instruction
);

    program_counter pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    instruction_memory imem (
        .address(pc),
        .instruction(instruction)
    );

endmodule