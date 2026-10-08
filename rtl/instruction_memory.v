module instruction_memory (
    input [15:0] address,
    output [15:0] instruction
);

reg [15:0] memory [0:255];

integer i;

initial begin

    for (i = 0; i < 256; i = i + 1)
        memory[i] = 16'h5000;

    memory[0]  = 16'b0000_011_001_010_000;
    memory[1]  = 16'b0001_100_011_001_000;
    memory[2]  = 16'b0010_101_011_100_000;
    memory[3]  = 16'b0011_110_011_100_000;
    memory[4]  = 16'b0110_111_110_000101;
    memory[5]  = 16'b1000_111_001_000101;
    memory[6]  = 16'b0111_110_001_000101;
    memory[7]  = 16'b0110_010_001_000000;
    memory[8]  = 16'b1001_000_001_010_010;
    memory[9]  = 16'b0110_111_111_000001;
    memory[10] = 16'b0110_110_110_000010;
    memory[11] = 16'b1010_000_000_000011;
    memory[12] = 16'b0110_111_111_000001;
    memory[13] = 16'h5000;
    memory[14] = 16'b0110_110_110_000011;

end

assign instruction = memory[address];

endmodule