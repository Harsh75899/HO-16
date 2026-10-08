`timescale 1ns/1ps

module final_regression_tb;

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

    // =========================================================
    // INITIAL REGISTER VALUES
    // =========================================================

    dut.rf.registers[0] = 16'd0;
    dut.rf.registers[1] = 16'd25;
    dut.rf.registers[2] = 16'd10;
    dut.rf.registers[3] = 16'd0;
    dut.rf.registers[4] = 16'd0;
    dut.rf.registers[5] = 16'd0;
    dut.rf.registers[6] = 16'd0;
    dut.rf.registers[7] = 16'd0;

    // Memory location used by LD/ST
    dut.data_mem.memory[30] = 16'd123;


    // =========================================================
    // PROGRAM
    // =========================================================

    // 0: ADD R3, R1, R2
    // R3 = 25 + 10 = 35
    dut.fetch.imem.memory[0] =
        16'b0000_011_001_010_000;

    // 1: SUB R4, R3, R1
    // Tests EX/MEM forwarding
    // R4 = 35 - 25 = 10
    dut.fetch.imem.memory[1] =
        16'b0001_100_011_001_000;

    // 2: NOP
    dut.fetch.imem.memory[2] = 16'h5000;

    // 3: LD R6, [R1 + 5]
    // Memory[30] = 123
    dut.fetch.imem.memory[3] =
        16'b0111_110_001_000101;

    // 4: ADD R5, R6, R2
    // Load-use hazard
    // R5 = 123 + 10 = 133
    dut.fetch.imem.memory[4] =
        16'b0000_101_110_010_000;

    // 5: ST R5, [R1 + 5]
    // Tests store-data forwarding
    // Memory[30] should become 133
    dut.fetch.imem.memory[5] =
        16'b1000_101_001_000101;

    // 6: ADDI R2, R1, 0
    // R2 = 25
    dut.fetch.imem.memory[6] =
        16'b0110_010_001_000000;

    // 7: BEQ R1, R2, +2
    // Taken
    dut.fetch.imem.memory[7] =
        16'b1001_000_001_010_010;

    // 8: WRONG PATH
    // Must be flushed
    // R7 must remain 0
    dut.fetch.imem.memory[8] =
        16'b0110_111_000_011111;

    // 9: Branch target / NOP
    dut.fetch.imem.memory[9] = 16'h5000;

    // 10: ADDI R6, R6, 2
    // R6 = 125
    dut.fetch.imem.memory[10] =
        16'b0110_110_110_000010;

    // 11: JMP +3
    // Jump to address 14
    dut.fetch.imem.memory[11] =
        16'b1010_000_000_000011;

    // 12: WRONG PATH
    // Must be flushed
    dut.fetch.imem.memory[12] =
        16'b0110_111_000_011111;

    // 13: WRONG PATH
    // Must also be flushed
    dut.fetch.imem.memory[13] =
        16'b0110_111_000_011111;

    // 14: Jump target
    // R6 = 125 + 3 = 128
    dut.fetch.imem.memory[14] =
        16'b0110_110_110_000011;

    // Remaining NOPs
    dut.fetch.imem.memory[15] = 16'h5000;


    // =========================================================
    // START
    // =========================================================

    #10;
    reset = 0;

    // Allow complete program to finish
    #220;


    // =========================================================
    // FINAL RESULTS
    // =========================================================

    $display("");
    $display("================================================");
    $display("          HO-16 FINAL REGRESSION");
    $display("================================================");

    if (dut.rf.registers[3] == 16'd35)
        $display("PASS: ADD      R3  = %d", dut.rf.registers[3]);
    else
        $display("FAIL: ADD      R3  = %d (expected 35)",
                 dut.rf.registers[3]);

    if (dut.rf.registers[4] == 16'd10)
        $display("PASS: SUB      R4  = %d", dut.rf.registers[4]);
    else
        $display("FAIL: SUB      R4  = %d (expected 10)",
                 dut.rf.registers[4]);

    if (dut.rf.registers[5] == 16'd133)
        $display("PASS: LOAD/USE R5  = %d", dut.rf.registers[5]);
    else
        $display("FAIL: LOAD/USE R5  = %d (expected 133)",
                 dut.rf.registers[5]);

    if (dut.data_mem.memory[30] == 16'd133)
        $display("PASS: STORE     MEM[30] = %d",
                 dut.data_mem.memory[30]);
    else
        $display("FAIL: STORE     MEM[30] = %d (expected 133)",
                 dut.data_mem.memory[30]);

    if (dut.rf.registers[7] == 16'd0)
        $display("PASS: BRANCH/JUMP FLUSH R7 = %d",
                 dut.rf.registers[7]);
    else
        $display("FAIL: WRONG-PATH R7 = %d (expected 0)",
                 dut.rf.registers[7]);

    if (dut.rf.registers[6] == 16'd128)
        $display("PASS: BRANCH/JUMP TARGET R6 = %d",
                 dut.rf.registers[6]);
    else
        $display("FAIL: TARGET R6 = %d (expected 128)",
                 dut.rf.registers[6]);

    $display("================================================");

    reset = 1;
    #10;

    $finish;

end


// =============================================================
// MONITOR
// =============================================================

initial begin

    $monitor(
        "Time=%0t | PC=%h | IF=%h | ID=%h | R3=%d | R4=%d | R5=%d | R6=%d | R7=%d | Stall=%b | FwdA=%b | FwdB=%b | Branch=%b | Jump=%b | Taken=%b | Flush=%b",
        $time,
        dut.pc,
        dut.instruction,
        dut.id_instruction,
        dut.rf.registers[3],
        dut.rf.registers[4],
        dut.rf.registers[5],
        dut.rf.registers[6],
        dut.rf.registers[7],
        dut.stall,
        dut.forward_a,
        dut.forward_b,
        dut.ex_branch,
        dut.ex_jump,
        dut.branch_taken,
        dut.flush
    );

end

endmodule