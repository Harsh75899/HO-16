`timescale 1ns/1ps

module instruction_memory_tb;

reg [15:0] address;
wire [15:0] instruction;

instruction_memory uut (
    .address(address),
    .instruction(instruction)
);

initial begin

    $dumpfile("sim/instruction_memory.vcd");
    $dumpvars(0, instruction_memory_tb);

    address = 16'd0;
    #1;
    $display("Address = %d, Instruction = %b", address, instruction);

    address = 16'd1;
    #1;
    $display("Address = %d, Instruction = %b", address, instruction);

    address = 16'd2;
    #1;
    $display("Address = %d, Instruction = %b", address, instruction);

    address = 16'd3;
    #1;
    $display("Address = %d, Instruction = %b", address, instruction);

    $finish;

end

endmodule