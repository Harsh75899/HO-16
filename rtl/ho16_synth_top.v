module ho16_synth_top (
    input clk,
    input reset,

    output [15:0] pc,
    output [15:0] instruction,
    output [15:0] next_pc
);

    ho16_processor dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction),
        .next_pc(next_pc)
    );

endmodule