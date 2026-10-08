module ho16_pipeline_timing_top (
    input clk,
    input reset,
    output [15:0] debug_pc,
    output [15:0] debug_instruction
);

    ho16_pipeline dut (
        .clk(clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction)
    );

endmodule