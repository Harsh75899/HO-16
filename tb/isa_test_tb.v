`timescale 1ns/1ps

module isa_test_tb;

reg clk;
reg reset;

integer pass_count;
integer fail_count;

ho16_processor uut (
    .clk(clk),
    .reset(reset)
);

always #5 clk = ~clk;

task check_register;
    input [2:0] reg_num;
    input [15:0] expected;
    input [127:0] test_name;

    begin
        if (uut.core.rf.registers[reg_num] == expected) begin
            $display("TEST: %s  PASS", test_name);
            pass_count = pass_count + 1;
        end
        else begin
            $display("TEST: %s  FAIL", test_name);
            $display("       Expected = %d", expected);
            $display("       Actual   = %d",
                     uut.core.rf.registers[reg_num]);
            fail_count = fail_count + 1;
        end
    end
endtask

initial begin

    $dumpfile("sim/isa_test.vcd");
    $dumpvars(0, isa_test_tb);

    clk = 0;
    reset = 1;

    pass_count = 0;
    fail_count = 0;

    // Initial register values
    uut.core.rf.registers[1] = 16'd35;
    uut.core.rf.registers[2] = 16'd10;

    // OR R3, R1, R2
    uut.fetch.imem.memory[0] = 16'b0011_011_001_010_000;

    // XOR R4, R1, R2
    uut.fetch.imem.memory[1] = 16'b0100_100_001_010_000;

    #10;
    reset = 0;

    #30;

    check_register(3, 16'd43, "OR");
    check_register(4, 16'd41, "XOR");

    $display("");
    $display("================================");
    $display("        HO-16 ISA TEST");
    $display("================================");

    $display("PASS = %d", pass_count);
    $display("FAIL = %d", fail_count);

    if (fail_count == 0)
        $display("ALL TESTS PASSED");
    else
        $display("SOME TESTS FAILED");

    $display("================================");

    $finish;

end

endmodule