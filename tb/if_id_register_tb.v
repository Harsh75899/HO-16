`timescale 1ns/1ps

module if_id_register_tb;

reg clk;
reg reset;

reg [15:0] pc_in;
reg [15:0] instruction_in;

wire [15:0] pc_out;
wire [15:0] instruction_out;

if_id_register dut (
    .clk(clk),
    .reset(reset),
    .pc_in(pc_in),
    .instruction_in(instruction_in),
    .pc_out(pc_out),
    .instruction_out(instruction_out)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    reset = 1;

    pc_in = 16'h0000;
    instruction_in = 16'h0000;

    #10;

    reset = 0;

    pc_in = 16'h0005;
    instruction_in = 16'h1234;

    #10;

    pc_in = 16'h0006;
    instruction_in = 16'hABCD;

    #10;

    reset = 1;

    #10;

    $finish;

end

initial begin
    $monitor(
        "Time=%0t | Reset=%b | PC_in=%h | Instr_in=%h | PC_out=%h | Instr_out=%h",
        $time,
        reset,
        pc_in,
        instruction_in,
        pc_out,
        instruction_out
    );
end

endmodule