`timescale 1ns/1ps

module store_forwarding_tb;

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

    // Clear target memory location
    dut.data_mem.memory[30] = 16'd0;

    // ADD R7, R1, R2
    dut.fetch.imem.memory[0] = 16'b0000_111_001_010_000;

    // ST R7, [R1 + 5]
    dut.fetch.imem.memory[1] = 16'b1000_111_001_000101;

    // NOPs
    dut.fetch.imem.memory[2] = 16'h5000;
    dut.fetch.imem.memory[3] = 16'h5000;
    dut.fetch.imem.memory[4] = 16'h5000;
    dut.fetch.imem.memory[5] = 16'h5000;
    dut.fetch.imem.memory[6] = 16'h5000;
    dut.fetch.imem.memory[7] = 16'h5000;

    #10;
    reset = 0;

    #80;

    $display("");
    $display("========================================");
    $display("       STORE FORWARDING TEST");
    $display("========================================");

    if (dut.rf.registers[7] == 16'd35)
        $display("PASS: R7 = %d", dut.rf.registers[7]);
    else
        $display("FAIL: R7 = %d (expected 35)", dut.rf.registers[7]);

    if (dut.data_mem.memory[30] == 16'd35)
        $display("PASS: MEM[30] = %d", dut.data_mem.memory[30]);
    else
        $display("FAIL: MEM[30] = %d (expected 35)",
                 dut.data_mem.memory[30]);

    $display("========================================");

    reset = 1;
    #10;
    $finish;

end

initial begin

    $monitor(
        "Time=%0t | PC=%h | IF=%h | ID=%h | EX_RD=%d | R7=%d | ALUResult=%d | MEM_ALU=%d | MEM_DATA=%d | MEM_W=%b | FwdA=%b | FwdB=%b | Stall=%b",
        $time,
        dut.pc,
        dut.instruction,
        dut.id_instruction,
        dut.ex_rd,
        dut.rf.registers[7],
        dut.ex_alu_result,
        dut.mem_alu_result,
        dut.mem_write_data,
        dut.mem_mem_write,
        dut.forward_a,
        dut.forward_b,
        dut.stall
    );

end

endmodule
