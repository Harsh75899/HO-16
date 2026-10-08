`timescale 1ns/1ps

module instruction_decoder_tb;

reg [15:0] instruction;

wire [3:0] opcode;
wire [2:0] rd;
wire [2:0] rs1;
wire [2:0] rs2;
wire [5:0] immediate;

instruction_decoder uut (
    .instruction(instruction),

    .opcode(opcode),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .immediate(immediate)
);

initial begin

    $dumpfile("sim/instruction_decoder.vcd");
    $dumpvars(0, instruction_decoder_tb);

    // ADD R3, R1, R2
    instruction = 16'b0000_011_001_010_000;

    #1;

    $display("Instruction = %b", instruction);
    $display("Opcode      = %b", opcode);
    $display("Rd          = %b", rd);
    $display("Rs1         = %b", rs1);
    $display("Rs2         = %b", rs2);
    $display("Immediate   = %b", immediate);

    $finish;

end

endmodule