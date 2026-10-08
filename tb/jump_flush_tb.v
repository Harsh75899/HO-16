`timescale 1ns/1ps

module jump_flush_tb;

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

    /*
       Address 0:
       JMP +3

       Current implementation:
       jump_target = ex_pc + ex_branch_offset

       So from PC=0:
       0 + 3 = 3
    */
    dut.fetch.imem.memory[0] = 16'b1010_000_000_000011;

    // Wrong-path instruction.
    // MUST be flushed.
    // ADDI R7, R0, 15
    dut.fetch.imem.memory[1] = 16'b0110_111_000_001111;

    // Another wrong-path instruction.
    // MUST also be flushed.
    // ADDI R7, R0, 20
    dut.fetch.imem.memory[2] = 16'b0110_111_000_010100;

    // Jump target = address 3
    // ADDI R6, R0, 31
    dut.fetch.imem.memory[3] = 16'b0110_110_000_011111;

    // NOPs
    dut.fetch.imem.memory[4] = 16'h5000;
    dut.fetch.imem.memory[5] = 16'h5000;
    dut.fetch.imem.memory[6] = 16'h5000;
    dut.fetch.imem.memory[7] = 16'h5000;
    dut.fetch.imem.memory[8] = 16'h5000;

    #10;
    reset = 0;

    #100;

    $display("");
    $display("========================================");
    $display("          JMP FLUSH TEST");
    $display("========================================");

    if (dut.rf.registers[7] == 16'd0)
        $display("PASS: Wrong-path instructions flushed, R7 = %d",
                 dut.rf.registers[7]);
    else
        $display("FAIL: Wrong-path instruction executed, R7 = %d",
                 dut.rf.registers[7]);

    if (dut.rf.registers[6] == 16'd31)
        $display("PASS: Jump target executed, R6 = %d",
                 dut.rf.registers[6]);
    else
        $display("FAIL: Jump target failed, R6 = %d (expected 31)",
                 dut.rf.registers[6]);

    $display("========================================");

    reset = 1;
    #10;
    $finish;

end

initial begin

    $monitor(
        "Time=%0t | PC=%h | IF=%h | ID=%h | EX_RD=%d | R6=%d | R7=%d | Branch=%b | Jump=%b | Taken=%b | Flush=%b | Stall=%b",
        $time,
        dut.pc,
        dut.instruction,
        dut.id_instruction,
        dut.ex_rd,
        dut.rf.registers[6],
        dut.rf.registers[7],
        dut.ex_branch,
        dut.ex_jump,
        dut.branch_taken,
        dut.flush,
        dut.stall
    );

end

endmodule