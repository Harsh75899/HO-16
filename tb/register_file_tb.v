`timescale 1ns/1ps

module register_file_tb;

reg clk;

reg [2:0] ReadAddr1;
reg [2:0] ReadAddr2;

wire [15:0] ReadData1;
wire [15:0] ReadData2;

reg RegWrite;
reg [2:0] WriteAddr;
reg [15:0] WriteData;

register_file uut (
    .clk(clk),

    .ReadAddr1(ReadAddr1),
    .ReadAddr2(ReadAddr2),

    .ReadData1(ReadData1),
    .ReadData2(ReadData2),

    .RegWrite(RegWrite),
    .WriteAddr(WriteAddr),
    .WriteData(WriteData)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("sim/register_file.vcd");
    $dumpvars(0, register_file_tb);

    clk = 0;
    RegWrite = 0;
    ReadAddr1 = 0;
    ReadAddr2 = 0;
    WriteAddr = 0;
    WriteData = 0;

    // Write 25 into R1
    #2;
    RegWrite = 1;
    WriteAddr = 3'b001;
    WriteData = 16'd25;

    #10;

    // Write 10 into R2
    WriteAddr = 3'b010;
    WriteData = 16'd10;

    #10;

    // Stop writing
    RegWrite = 0;

    // Read R1 and R2 simultaneously
    ReadAddr1 = 3'b001;
    ReadAddr2 = 3'b010;

    #1;

    $display("R1 = %d", ReadData1);
    $display("R2 = %d", ReadData2);

    $finish;

end
endmodule