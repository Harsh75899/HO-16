`timescale 1ns/1ps

module ho16_pipeline_tb;

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
    dut.rf.registers[0] = 16'd0;
    dut.rf.registers[1] = 16'd25;
    dut.rf.registers[2] = 16'd10;
    dut.rf.registers[3] = 16'd0;
    dut.rf.registers[4] = 16'd0;
    dut.rf.registers[5] = 16'd0;
    dut.rf.registers[6] = 16'd0;
    dut.rf.registers[7] = 16'd0;

    #10;

    reset = 0;

    #300;

    $display("");
    $display("========================================");
    $display("        HO-16 PIPELINE TEST RESULTS");
    $display("========================================");

    if (dut.rf.registers[3] == 16'd35)
        $display("PASS: R3 = %d", dut.rf.registers[3]);
    else
        $display("FAIL: R3 = %d (expected 35)", dut.rf.registers[3]);

    if (dut.rf.registers[4] == 16'd10)
        $display("PASS: R4 = %d", dut.rf.registers[4]);
    else
        $display("FAIL: R4 = %d (expected 10)", dut.rf.registers[4]);

    if (dut.rf.registers[5] == 16'd2)
        $display("PASS: R5 = %d", dut.rf.registers[5]);
    else
        $display("FAIL: R5 = %d (expected 2)", dut.rf.registers[5]);

    if (dut.rf.registers[6] == 16'd53)
        $display("PASS: R6 = %d", dut.rf.registers[6]);
    else
        $display("FAIL: R6 = %d (expected 53)", dut.rf.registers[6]);

    if (dut.rf.registers[7] == 16'd48)
        $display("PASS: R7 = %d", dut.rf.registers[7]);
    else
        $display("FAIL: R7 = %d (expected 48)", dut.rf.registers[7]);

    if (dut.data_mem.memory[30] == 16'd48)
        $display("PASS: MEM[30] = %d", dut.data_mem.memory[30]);
    else
        $display("FAIL: MEM[30] = %d (expected 48)", dut.data_mem.memory[30]);

    reset = 1;
    #10;
    $finish;
    end

initial begin

    $monitor(
        "Time=%0t | PC=%h | IF=%h | ID=%h | EX_RD=%d | R1=%h | R2=%h | IMM=%h | ALUB=%h | ALUResult=%h | MEM_ALU=%h | MEM_DATA=%h | MEM_RD=%d | RegW=%b | MemR=%b | MemW=%b | MemData=%h | WB=%h | Stall=%b | FwdA=%b | FwdB=%b",
        $time,
        dut.pc,
        dut.instruction,
        dut.id_instruction,
        dut.ex_rd,
        dut.ex_read_data1,
        dut.ex_read_data2,
        dut.ex_immediate,
        dut.alu_b,
        dut.ex_alu_result,
        dut.mem_alu_result,
        dut.mem_write_data,
        dut.mem_rd,
        dut.mem_reg_write,
        dut.mem_mem_read,
        dut.mem_mem_write,
        dut.mem_read_data,
        dut.writeback_data,
        dut.stall,
        dut.forward_a,
        dut.forward_b
    );

end

endmodule