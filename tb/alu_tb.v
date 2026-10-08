`timescale 1ns/1ps

module alu_tb;

reg  [15:0] A;
reg  [15:0] B;
reg  [2:0]  ALU_Sel;

wire [15:0] Result;
wire        Zero;

integer test_no;

alu uut (
    .A(A),
    .B(B),
    .ALU_Sel(ALU_Sel),
    .Result(Result),
    .Zero(Zero)
);

task check_result;
    input [15:0] test_A;
    input [15:0] test_B;
    input [2:0]  test_sel;
    input [15:0] expected;
    begin

        A = test_A;
        B = test_B;
        ALU_Sel = test_sel;

        #1;

        if (Result == expected)
            $display("TEST %0d : PASS | A=%h B=%h SEL=%b RESULT=%h",
                     test_no, A, B, ALU_Sel, Result);
        else
            $display("TEST %0d : FAIL | A=%h B=%h SEL=%b EXPECTED=%h ACTUAL=%h",
                     test_no, A, B, ALU_Sel, expected, Result);

        test_no = test_no + 1;

    end
endtask

initial begin

    $dumpfile("sim/alu.vcd");
    $dumpvars(0, alu_tb);

    test_no = 1;

    // ADD
    check_result(16'd10, 16'd5, 3'b000, 16'd15);

    // SUB
    check_result(16'd10, 16'd5, 3'b001, 16'd5);

    // AND
    check_result(16'd10, 16'd5, 3'b010, 16'd0);

    // OR
    check_result(16'd10, 16'd5, 3'b011, 16'd15);

    // XOR
    check_result(16'd10, 16'd5, 3'b100, 16'd15);

    // ZERO RESULT
    check_result(16'd5, 16'd5, 3'b001, 16'd0);

    #1;

    $finish;

end

endmodule