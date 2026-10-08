`timescale 1ns/1ps

module branch_unit_tb;

reg Branch;
reg Zero;

reg [15:0] pc;
reg [15:0] offset;

wire [15:0] next_pc;

branch_unit uut (
    .Branch(Branch),
    .Zero(Zero),
    .pc(pc),
    .offset(offset),
    .next_pc(next_pc)
);

initial begin

    $dumpfile("sim/branch_unit.vcd");
    $dumpvars(0, branch_unit_tb);

    pc = 16'd10;
    offset = 16'd3;


    // Case 1: Normal execution
    Branch = 0;
    Zero = 1;

    #1;

    $display("Normal: next_pc = %d", next_pc);


    // Case 2: Branch signal but condition false
    Branch = 1;
    Zero = 0;

    #1;

    $display("Not taken: next_pc = %d", next_pc);


    // Case 3: Branch taken
    Branch = 1;
    Zero = 1;

    #1;

    $display("Taken: next_pc = %d", next_pc);


    $finish;

end

endmodule