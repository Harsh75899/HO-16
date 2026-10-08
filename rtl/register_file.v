module register_file (
    input        clk,

    input  [2:0] ReadAddr1,
    input  [2:0] ReadAddr2,

    output [15:0] ReadData1,
    output [15:0] ReadData2,

    input        RegWrite,
    input  [2:0] WriteAddr,
    input  [15:0] WriteData
);

reg [15:0] registers [0:7];

always @(posedge clk) begin

    if (RegWrite)
        registers[WriteAddr] <= WriteData;

end

assign ReadData1 =
    (RegWrite && (WriteAddr != 3'd0) && (WriteAddr == ReadAddr1))
    ? WriteData
    : registers[ReadAddr1];

assign ReadData2 =
    (RegWrite && (WriteAddr != 3'd0) && (WriteAddr == ReadAddr2))
    ? WriteData
    : registers[ReadAddr2];

endmodule