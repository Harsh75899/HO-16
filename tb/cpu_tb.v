`timescale 1ns/1ps

module cpu_tb;

reg clk;
reg [15:0] instruction;


// --------------------------------
// Create CPU
// --------------------------------

cpu uut (
    .instruction(instruction),
    .clk(clk)
);


// --------------------------------
// Clock
// --------------------------------

always #5 clk = ~clk;


// --------------------------------
// Test
// --------------------------------

initial begin

    $dumpfile("sim/cpu.vcd");
    $dumpvars(0, cpu_tb);

    clk = 0;

    // --------------------------------
    // Put test values into registers
    // --------------------------------

    uut.rf.registers[1] = 16'd25;
    uut.rf.registers[2] = 16'd10;


    // --------------------------------
    // ADD R3, R1, R2
    //
    // opcode = 0000
    // Rd     = 011 (R3)
    // Rs1    = 001 (R1)
    // Rs2    = 010 (R2)
    // --------------------------------

    instruction = 16'b0000_011_001_010_000;


    // Wait for clock edge
    #10;


    // --------------------------------
    // Check result
    // --------------------------------

    $display("R1 = %d", uut.rf.registers[1]);
    $display("R2 = %d", uut.rf.registers[2]);
    $display("R3 = %d", uut.rf.registers[3]);


    $finish;

end

endmodule