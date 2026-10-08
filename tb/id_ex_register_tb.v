`timescale 1ns/1ps

module id_ex_register_tb;

reg clk;
reg reset;

// Data
reg [15:0] pc_in;
reg [15:0] read_data1_in;
reg [15:0] read_data2_in;
reg [15:0] immediate_in;

// Destination
reg [2:0] rd_in;

// Control
reg [2:0] alu_sel_in;
reg       reg_write_in;
reg       alu_src_in;
reg       mem_read_in;
reg       mem_write_in;
reg       mem_to_reg_in;
reg       branch_in;
reg       jump_in;

// Outputs
wire [15:0] pc_out;
wire [15:0] read_data1_out;
wire [15:0] read_data2_out;
wire [15:0] immediate_out;

wire [2:0] rd_out;

wire [2:0] alu_sel_out;
wire       reg_write_out;
wire       alu_src_out;
wire       mem_read_out;
wire       mem_write_out;
wire       mem_to_reg_out;
wire       branch_out;
wire       jump_out;

id_ex_register dut (
    .clk(clk),
    .reset(reset),

    .pc_in(pc_in),
    .read_data1_in(read_data1_in),
    .read_data2_in(read_data2_in),
    .immediate_in(immediate_in),

    .rd_in(rd_in),

    .alu_sel_in(alu_sel_in),
    .reg_write_in(reg_write_in),
    .alu_src_in(alu_src_in),
    .mem_read_in(mem_read_in),
    .mem_write_in(mem_write_in),
    .mem_to_reg_in(mem_to_reg_in),
    .branch_in(branch_in),
    .jump_in(jump_in),

    .pc_out(pc_out),
    .read_data1_out(read_data1_out),
    .read_data2_out(read_data2_out),
    .immediate_out(immediate_out),

    .rd_out(rd_out),

    .alu_sel_out(alu_sel_out),
    .reg_write_out(reg_write_out),
    .alu_src_out(alu_src_out),
    .mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out),
    .mem_to_reg_out(mem_to_reg_out),
    .branch_out(branch_out),
    .jump_out(jump_out)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    reset = 1;

    pc_in = 16'h0000;
    read_data1_in = 16'h0000;
    read_data2_in = 16'h0000;
    immediate_in = 16'h0000;

    rd_in = 3'd0;

    alu_sel_in = 3'd0;
    reg_write_in = 0;
    alu_src_in = 0;
    mem_read_in = 0;
    mem_write_in = 0;
    mem_to_reg_in = 0;
    branch_in = 0;
    jump_in = 0;

    #10;

    reset = 0;

    // Test instruction data
    pc_in = 16'h0005;
    read_data1_in = 16'h0019;
    read_data2_in = 16'h000A;
    immediate_in = 16'h0005;

    rd_in = 3'd3;

    alu_sel_in = 3'd0;
    reg_write_in = 1;
    alu_src_in = 0;
    mem_read_in = 0;
    mem_write_in = 0;
    mem_to_reg_in = 0;
    branch_in = 0;
    jump_in = 0;

    #10;

    // Test memory instruction
    pc_in = 16'h0006;
    read_data1_in = 16'h0019;
    read_data2_in = 16'h0030;
    immediate_in = 16'h0005;

    rd_in = 3'd7;

    alu_sel_in = 3'd0;
    reg_write_in = 0;
    alu_src_in = 1;
    mem_read_in = 0;
    mem_write_in = 1;
    mem_to_reg_in = 0;
    branch_in = 0;
    jump_in = 0;

    #10;

    // Test branch
    pc_in = 16'h0008;
    read_data1_in = 16'h0019;
    read_data2_in = 16'h0019;
    immediate_in = 16'h0002;

    rd_in = 3'd0;

    alu_sel_in = 3'd1;
    reg_write_in = 0;
    alu_src_in = 0;
    mem_read_in = 0;
    mem_write_in = 0;
    mem_to_reg_in = 0;
    branch_in = 1;
    jump_in = 0;

    #10;

    // Reset
    reset = 1;

    #10;

    $finish;

end

initial begin

    $monitor(
        "Time=%0t | Reset=%b | PC=%h | R1=%h | R2=%h | Imm=%h | RD=%d | ALU=%d | RegW=%b | ALUSrc=%b | MemR=%b | MemW=%b | MemToReg=%b | Branch=%b | Jump=%b",
        $time,
        reset,
        pc_out,
        read_data1_out,
        read_data2_out,
        immediate_out,
        rd_out,
        alu_sel_out,
        reg_write_out,
        alu_src_out,
        mem_read_out,
        mem_write_out,
        mem_to_reg_out,
        branch_out,
        jump_out
    );

end

endmodule