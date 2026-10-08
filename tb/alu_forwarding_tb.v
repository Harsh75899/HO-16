`timescale 1ns/1ps

module alu_forwarding_tb;

reg clk;
reg reset;

ho16_pipeline dut (
    .clk(clk),
    .reset(reset)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    reset = 1;

    // Initial registers
    dut.rf.registers[0] = 16'd0;
    dut.rf.registers[1] = 16'd25;
    dut.rf.registers[2] = 16'd10;
    dut.rf.registers[3] = 16'd0;
    dut.rf.registers[4] = 16'd0;
    dut.rf.registers[5] = 16'd0;
    dut.rf.registers[6] = 16'd0;
    dut.rf.registers[7] = 16'd0;

    // ADD R3, R1, R2
    dut.fetch.imem.memory[0] = 16'b0000_011_001_010_000;

    // SUB R4, R3, R1
    dut.fetch.imem.memory[1] = 16'b0001_100_011_001_000;

    // NOPs
    dut.fetch.imem.memory[2] = 16'h5000;
    dut.fetch.imem.memory[3] = 16'h5000;
    dut.fetch.imem.memory[4] = 16'h5000;
    dut.fetch.imem.memory[5] = 16'h5000;
    dut.fetch.imem.memory[6] = 16'h5000;
    dut.fetch.imem.memory[7] = 16'h5000;

    #10;
    reset = 0;

    #70;

    $display("");
    $display("========================================");
    $display("       ALU FORWARDING TEST");
    $display("========================================");

    if (dut.rf.registers[3] == 16'd35)
        $display("PASS: R3 = %d", dut.rf.registers[3]);
    else
        $display("FAIL: R3 = %d (expected 35)", dut.rf.registers[3]);

    if (dut.rf.registers[4] == 16'd10)
        $display("PASS: R4 = %d", dut.rf.registers[4]);
    else
        $display("FAIL: R4 = %d (expected 10)", dut.rf.registers[4]);

    $display("========================================");

    reset = 1;
    #10;
    $finish;

end

initial begin

    $monitor(
        "Time=%0t | PC=%h | IF=%h | ID=%h | EX_RD=%d | R3=%d | R4=%d | ALUResult=%d | FwdA=%b | FwdB=%b | Stall=%b",
        $time,
        dut.pc,
        dut.instruction,
        dut.id_instruction,
        dut.ex_rd,
        dut.rf.registers[3],
        dut.rf.registers[4],
        dut.ex_alu_result,
        dut.forward_a,
        dut.forward_b,
        dut.stall
    );

end

endmodule
