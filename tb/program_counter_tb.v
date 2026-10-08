`timescale 1ns/1ps

module program_counter_tb;

reg clk;
reg reset;

wire [15:0] pc;

program_counter uut (
    .clk(clk),
    .reset(reset),
    .pc(pc)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("sim/program_counter.vcd");
    $dumpvars(0, program_counter_tb);

    clk = 0;
    reset = 1;

    #10;

    reset = 0;

    #50;

    $finish;

end

endmodule