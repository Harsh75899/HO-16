module ho16_timing_top (
    input clk,
    input reset
);

wire [15:0] pc;
wire [15:0] instruction;
wire [15:0] next_pc;

(* keep *) wire [15:0] timing_pc;
(* keep *) wire [15:0] timing_instruction;
(* keep *) wire [15:0] timing_next_pc;

assign timing_pc = pc;
assign timing_instruction = instruction;
assign timing_next_pc = next_pc;

ho16_processor dut (
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .instruction(instruction),
    .next_pc(next_pc)
);

endmodule