`timescale 1ns/1ps

module branch_flush_tb;

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
    dut.rf.registers[2] = 16'd25;
    dut.rf.registers[3] = 16'd0;
    dut.rf.registers[4] = 16'd0;
    dut.rf.registers[5] = 16'd0;
    dut.rf.registers[6] = 16'd0;
    dut.rf.registers[7] = 16'd0;

    // BEQ R1, R2, +2
    // R1 == R2, so branch MUST be taken.
    dut.fetch.imem.memory[0] = 16'b1001_000_001_010_010;

    // Wrong-path instruction.
    // This MUST be flushed.
    // If it executes, R7 becomes 99.
    dut.fetch.imem.memory[1] = 16'b0110_111_000_110001;

    // Branch target: address 2
    dut.fetch.imem.memory[2] = 16'h5000;

    // Target instruction.
    // R6 should become 55.
    dut.fetch.imem.memory[3] = 16'b0110_110_000_011111;

    // More NOPs
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
    $display("        BRANCH FLUSH TEST");
    $display("========================================");

    if (dut.rf.registers[7] == 16'd0)
        $display("PASS: Wrong-path instruction flushed, R7 = %d",
                 dut.rf.registers[7]);
    else
        $display("FAIL: Wrong-path instruction executed, R7 = %d",
                 dut.rf.registers[7]);

    if (dut.rf.registers[6] == 16'd31)
        $display("PASS: Branch target executed, R6 = %d",
                dut.rf.registers[6]);
    else
        $display("FAIL: Branch target failed, R6 = %d (expected 31)",
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