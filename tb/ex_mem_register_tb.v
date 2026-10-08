`timescale 1ns/1ps

module ex_mem_register_tb;

reg clk;
reg reset;

reg [15:0] alu_result_in;
reg [15:0] read_data2_in;
reg [2:0]  rd_in;

reg reg_write_in;
reg mem_read_in;
reg mem_write_in;
reg mem_to_reg_in;

wire [15:0] alu_result_out;
wire [15:0] read_data2_out;
wire [2:0]  rd_out;

wire reg_write_out;
wire mem_read_out;
wire mem_write_out;
wire mem_to_reg_out;

ex_mem_register dut (
    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result_in),
    .read_data2_in(read_data2_in),
    .rd_in(rd_in),

    .reg_write_in(reg_write_in),
    .mem_read_in(mem_read_in),
    .mem_write_in(mem_write_in),
    .mem_to_reg_in(mem_to_reg_in),

    .alu_result_out(alu_result_out),
    .read_data2_out(read_data2_out),
    .rd_out(rd_out),

    .reg_write_out(reg_write_out),
    .mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out),
    .mem_to_reg_out(mem_to_reg_out)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    reset = 1;

    alu_result_in = 16'h0000;
    read_data2_in = 16'h0000;
    rd_in = 3'd0;

    reg_write_in = 0;
    mem_read_in = 0;
    mem_write_in = 0;
    mem_to_reg_in = 0;

    #10;

    reset = 0;

    // ALU instruction
    alu_result_in = 16'h002A;
    read_data2_in = 16'h0019;
    rd_in = 3'd3;

    reg_write_in = 1;
    mem_read_in = 0;
    mem_write_in = 0;
    mem_to_reg_in = 0;

    #10;

    // Store instruction
    alu_result_in = 16'h001E;
    read_data2_in = 16'h0030;
    rd_in = 3'd7;

    reg_write_in = 0;
    mem_read_in = 0;
    mem_write_in = 1;
    mem_to_reg_in = 0;

    #10;

    // Load instruction
    alu_result_in = 16'h001E;
    read_data2_in = 16'h0000;
    rd_in = 3'd6;

    reg_write_in = 1;
    mem_read_in = 1;
    mem_write_in = 0;
    mem_to_reg_in = 1;

    #10;

    // Reset
    reset = 1;

    #10;

    $finish;

end

initial begin

    $monitor(
        "Time=%0t | Reset=%b | ALU=%h | StoreData=%h | RD=%d | RegW=%b | MemR=%b | MemW=%b | MemToReg=%b",
        $time,
        reset,
        alu_result_out,
        read_data2_out,
        rd_out,
        reg_write_out,
        mem_read_out,
        mem_write_out,
        mem_to_reg_out
    );

end

endmodule