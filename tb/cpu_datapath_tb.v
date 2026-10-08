`timescale 1ns/1ps

module cpu_datapath_tb;

reg clk;

// Register File signals
reg [2:0] ReadAddr1;
reg [2:0] ReadAddr2;
reg [2:0] WriteAddr;

reg [15:0] WriteData;
reg RegWrite;

wire [15:0] ReadData1;
wire [15:0] ReadData2;

// ALU signals
reg [2:0] ALU_Sel;
wire [15:0] ALU_Result;
wire ALU_Zero;


// Register File
register_file rf (
    .clk(clk),

    .ReadAddr1(ReadAddr1),
    .ReadAddr2(ReadAddr2),

    .ReadData1(ReadData1),
    .ReadData2(ReadData2),

    .RegWrite(RegWrite),
    .WriteAddr(WriteAddr),
    .WriteData(WriteData)
);


// ALU
alu alu_unit (
    .A(ReadData1),
    .B(ReadData2),
    .ALU_Sel(ALU_Sel),
    .Result(ALU_Result),
    .Zero(ALU_Zero)
);


// Clock
always #5 clk = ~clk;


initial begin

    $dumpfile("sim/cpu_datapath.vcd");
    $dumpvars(0, cpu_datapath_tb);

    // Initial values
    clk = 0;

    ReadAddr1 = 0;
    ReadAddr2 = 0;

    WriteAddr = 0;
    WriteData = 0;

    RegWrite = 0;
    ALU_Sel = 0;


    // --------------------------------
    // Write 25 into R1
    // --------------------------------

    #2;

    RegWrite = 1;
    WriteAddr = 3'b001;
    WriteData = 16'd25;

    #10;


    // --------------------------------
    // Write 10 into R2
    // --------------------------------

    WriteAddr = 3'b010;
    WriteData = 16'd10;

    #10;


    // Stop writing
    RegWrite = 0;


    // --------------------------------
    // Read R1 and R2
    // --------------------------------

    ReadAddr1 = 3'b001;
    ReadAddr2 = 3'b010;


    // ADD
    ALU_Sel = 3'b000;

    #1;


    $display("R1 = %d", ReadData1);
    $display("R2 = %d", ReadData2);
    $display("ALU Result = %d", ALU_Result);


    // --------------------------------
    // Write ALU result into R3
    // --------------------------------

    RegWrite = 1;
    WriteAddr = 3'b011;
    WriteData = ALU_Result;

    #10;


    // Stop writing
    RegWrite = 0;


    // Read R3
    ReadAddr1 = 3'b011;

    #1;

    $display("R3 = %d", ReadData1);


    $finish;

end

endmodule