`timescale 1ns/1ps

module ho16_processor_tb;

reg clk;
reg reset;

integer pass_count;
integer fail_count;


// ------------------------------------
// PROCESSOR
// ------------------------------------

ho16_processor uut (
    .clk(clk),
    .reset(reset)
);


// ------------------------------------
// CLOCK
// ------------------------------------

always #5 clk = ~clk;


// ------------------------------------
// CHECK TASK
// ------------------------------------

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
task check_memory;
    input [7:0] address;
    input [15:0] expected;
    input [127:0] test_name;

    begin
        if (uut.core.data_mem.memory[address] == expected) begin
            $display("TEST: %s  PASS", test_name);
            pass_count = pass_count + 1;
        end
        else begin
            $display("TEST: %s  FAIL", test_name);
            $display("       Expected = %d", expected);
            $display("       Actual   = %d",
                     uut.core.data_mem.memory[address]);
            fail_count = fail_count + 1;
        end
    end
endtask
task check_pc;
    input [15:0] expected;
    input [127:0] test_name;

    begin
        if (uut.fetch.pc == expected) begin
            $display("TEST: %s  PASS", test_name);
            pass_count = pass_count + 1;
        end
        else begin
            $display("TEST: %s  FAIL", test_name);
            $display("       Expected PC = %h", expected);
            $display("       Actual PC   = %h", uut.fetch.pc);
            fail_count = fail_count + 1;
        end
    end
endtask
task check_pc_transition;
    input [15:0] expected_from;
    input [15:0] expected_to;
    input [127:0] test_name;

    begin
        wait(uut.fetch.pc == expected_from);

        @(posedge clk);
        #1;

        if (uut.fetch.pc == expected_to) begin
            $display("TEST: %s  PASS", test_name);
            pass_count = pass_count + 1;
        end
        else begin
            $display("TEST: %s  FAIL", test_name);
            $display("       Expected PC = %h", expected_to);
            $display("       Actual PC   = %h", uut.fetch.pc);
            fail_count = fail_count + 1;
        end
    end
endtask
// ------------------------------------
// TEST
// ------------------------------------

initial begin

    $dumpfile("sim/ho16_processor.vcd");
    $dumpvars(0, ho16_processor_tb);

    clk = 0;
    reset = 1;

    pass_count = 0;
    fail_count = 0;


    // --------------------------------
    // INITIAL REGISTER VALUES
    // --------------------------------

    uut.core.rf.registers[1] = 16'd25;
    uut.core.rf.registers[2] = 16'd10;


    // --------------------------------
    // RESET
    // --------------------------------

    #10;
    reset = 0;
    check_pc_transition(16'h0007, 16'h0008, "PC SEQUENTIAL");
    check_pc_transition(16'h0008, 16'h000A, "BEQ PC JUMP");
    check_pc_transition(16'h000B, 16'h000E, "JMP PC JUMP");
    

    // --------------------------------
    // RUN PROCESSOR
    // --------------------------------

    #180;


    // --------------------------------
    // CHECK RESULTS
    // --------------------------------

    check_register(
        3,
        16'd35,
        "ADD"
    );

    check_register(
        4,
        16'd10,
        "SUB"
    );

    check_register(
        5,
        16'd2,
        "AND"
    );

    check_register(
        7,
        16'd48,
        "ADDI"
    );

    check_register(
        6,
        16'd53,
        "JMP"
    );
    check_memory(30, 16'd48, "ST");
    check_register(6, 16'd53, "LD");
    check_register(7, 16'd48, "BEQ");
    


    // --------------------------------
    // FINAL RESULT
    // --------------------------------

    $display("");
    $display("================================");
    $display("        HO-16 CPU TEST");
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