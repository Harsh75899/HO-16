`timescale 1ns/1ps

module load_use_hazard_tb;

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

    // Initial register values
    dut.rf.registers[0] = 16'd0;
    dut.rf.registers[1] = 16'd25;
    dut.rf.registers[2] = 16'd10;
    dut.rf.registers[3] = 16'd0;
    dut.rf.registers[4] = 16'd0;
    dut.rf.registers[5] = 16'd0;
    dut.rf.registers[6] = 16'd0;
    dut.rf.registers[7] = 16'd0;

    // Memory[25 + 5] = 123
    dut.data_mem.memory[30] = 16'd123;

    // Test program
    // LD R6, [R1 + 5]
    dut.fetch.imem.memory[0] = 16'b0111_110_001_000101;

    // ADD R3, R6, R2
    dut.fetch.imem.memory[1] = 16'b0000_011_110_010_000;

    // NOPs
    dut.fetch.imem.memory[2] = 16'h5000;
    dut.fetch.imem.memory[3] = 16'h5000;
    dut.fetch.imem.memory[4] = 16'h5000;
    dut.fetch.imem.memory[5]  = 16'h5000;
    dut.fetch.imem.memory[6]  = 16'h5000;
    dut.fetch.imem.memory[7]  = 16'h5000;
    dut.fetch.imem.memory[8]  = 16'h5000;
    dut.fetch.imem.memory[9]  = 16'h5000;
    dut.fetch.imem.memory[10] = 16'h5000;
    dut.fetch.imem.memory[11] = 16'h5000;
    dut.fetch.imem.memory[12] = 16'h5000;
    dut.fetch.imem.memory[13] = 16'h5000;
    dut.fetch.imem.memory[14] = 16'h5000;

    #10;
    reset = 0;

    #70;

    $display("");
    $display("========================================");
    $display("       LOAD-USE HAZARD TEST");
    $display("========================================");

    if (dut.rf.registers[6] == 16'd123)
        $display("PASS: R6 = %d", dut.rf.registers[6]);
    else
        $display("FAIL: R6 = %d (expected 123)", dut.rf.registers[6]);

    if (dut.rf.registers[3] == 16'd133)
        $display("PASS: R3 = %d", dut.rf.registers[3]);
    else
        $display("FAIL: R3 = %d (expected 133)", dut.rf.registers[3]);

    if (dut.data_mem.memory[30] == 16'd123)
        $display("PASS: MEM[30] = %d", dut.data_mem.memory[30]);
    else
        $display("FAIL: MEM[30] = %d (expected 123)", dut.data_mem.memory[30]);

    $display("========================================");

    reset = 1;
    #10;
    $finish;

end

initial begin

    $monitor(
        "Time=%0t | PC=%h | IF=%h | ID=%h | EX_RD=%d | R6=%d | R3=%d | Stall=%b | FwdA=%b | FwdB=%b",
        $time,
        dut.pc,
        dut.instruction,
        dut.id_instruction,
        dut.ex_rd,
        dut.rf.registers[6],
        dut.rf.registers[3],
        dut.stall,
        dut.forward_a,
        dut.forward_b
    );

end

endmodule
