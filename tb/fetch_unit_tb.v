`timescale 1ns/1ps

module fetch_unit_tb;

reg clk;
reg reset;

wire [15:0] pc;
wire [15:0] instruction;

fetch_unit uut (
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .instruction(instruction)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("sim/fetch_unit.vcd");
    $dumpvars(0, fetch_unit_tb);

    clk = 0;
    reset = 1;

    // Keep PC at zero during reset
    #10;

    reset = 0;

    // Let PC run
    #40;

    $finish;

end

endmodule
