module data_memory (
    input        clk,
    input        MemRead,
    input        MemWrite,

    input  [15:0] address,
    input  [15:0] WriteData,

    output [15:0] ReadData
);

reg [15:0] memory [0:255];

always @(posedge clk) begin

    if (MemWrite)
        memory[address] <= WriteData;

end

assign ReadData = MemRead ? memory[address] : 16'b0;

endmodule