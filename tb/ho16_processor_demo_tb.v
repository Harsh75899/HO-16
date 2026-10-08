`timescale 1ns/1ps

module ho16_processor_tb;

reg clk;
reg reset;

ho16_processor uut (
    .clk(clk),
    .reset(reset)
);


// Clock
always #5 clk = ~clk;


initial begin

    $dumpfile("sim/ho16_processor.vcd");
    $dumpvars(0, ho16_processor_tb);

    clk = 0;
    reset = 1;

    // Give R1 and R2 initial values
    uut.core.rf.registers[1] = 16'd25;
    uut.core.rf.registers[2] = 16'd10;

    // Reset
    #10;

    reset = 0;

    // Let processor execute
    #170;

    // Display register values
    $display("R1 = %d", uut.core.rf.registers[1]);
    $display("R2 = %d", uut.core.rf.registers[2]);
    $display("R3 = %d", uut.core.rf.registers[3]);
    $display("R4 = %d", uut.core.rf.registers[4]);
    $display("R5 = %d", uut.core.rf.registers[5]);
    $display("R6 = %d", uut.core.rf.registers[6]);
    $display("R7 = %d", uut.core.rf.registers[7]);

    $finish;

end

endmodule