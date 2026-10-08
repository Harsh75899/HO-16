`timescale 1ns/1ps

module data_memory_tb;

reg clk;
reg MemRead;
reg MemWrite;

reg [15:0] address;
reg [15:0] WriteData;

wire [15:0] ReadData;


data_memory uut (
    .clk(clk),
    .MemRead(MemRead),
    .MemWrite(MemWrite),

    .address(address),
    .WriteData(WriteData),
    .ReadData(ReadData)
);


always #5 clk = ~clk;


initial begin

    $dumpfile("sim/data_memory.vcd");
    $dumpvars(0, data_memory_tb);

    clk = 0;
    MemRead = 0;
    MemWrite = 0;

    address = 0;
    WriteData = 0;


    // -------------------------
    // Write 123 to address 20
    // -------------------------

    #2;

    address = 16'd20;
    WriteData = 16'd123;
    MemWrite = 1;

    #10;

    MemWrite = 0;


    // -------------------------
    // Read address 20
    // -------------------------

    MemRead = 1;

    #1;

    $display("Memory[20] = %d", ReadData);


    // -------------------------
    // Write 456 to address 30
    // -------------------------

    MemRead = 0;

    address = 16'd30;
    WriteData = 16'd456;
    MemWrite = 1;

    #10;

    MemWrite = 0;


    // -------------------------
    // Read address 30
    // -------------------------

    MemRead = 1;

    #1;

    $display("Memory[30] = %d", ReadData);


    $finish;

end

endmodule