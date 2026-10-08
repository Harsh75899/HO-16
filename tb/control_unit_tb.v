`timescale 1ns/1ps

module control_unit_tb;

reg [3:0] opcode;

wire [2:0] ALU_Sel;
wire RegWrite;

control_unit uut (
    .opcode(opcode),
    .ALU_Sel(ALU_Sel),
    .RegWrite(RegWrite)
);

initial begin

    $dumpfile("sim/control_unit.vcd");
    $dumpvars(0, control_unit_tb);

    // ADD
    opcode = 4'b0000;
    #1;
    $display("ADD : ALU_Sel=%b RegWrite=%b",
             ALU_Sel, RegWrite);

    // SUB
    opcode = 4'b0001;
    #1;
    $display("SUB : ALU_Sel=%b RegWrite=%b",
             ALU_Sel, RegWrite);

    // AND
    opcode = 4'b0010;
    #1;
    $display("AND : ALU_Sel=%b RegWrite=%b",
             ALU_Sel, RegWrite);

    // OR
    opcode = 4'b0011;
    #1;
    $display("OR  : ALU_Sel=%b RegWrite=%b",
             ALU_Sel, RegWrite);

    // XOR
    opcode = 4'b0100;
    #1;
    $display("XOR : ALU_Sel=%b RegWrite=%b",
             ALU_Sel, RegWrite);

    // Invalid/reserved opcode
    opcode = 4'b1111;
    #1;
    $display("INVALID : ALU_Sel=%b RegWrite=%b",
             ALU_Sel, RegWrite);

    $finish;

end

endmodule