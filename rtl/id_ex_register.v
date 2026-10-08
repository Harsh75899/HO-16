module id_ex_register (
    input clk,
    input reset,
    input stall,
    input flush,

    input [15:0] pc_in,
    input [15:0] read_data1_in,
    input [15:0] read_data2_in,
    input [15:0] immediate_in,
    input [15:0] branch_offset_in,

    input [2:0] rd_in,
    input [2:0] rs1_in,
    input [2:0] rs2_in,
    input [2:0] alu_sel_in,

    input reg_write_in,
    input alu_src_in,
    input mem_read_in,
    input mem_write_in,
    input mem_to_reg_in,
    input branch_in,
    input jump_in,

    output reg [15:0] pc_out,
    output reg [15:0] read_data1_out,
    output reg [15:0] read_data2_out,
    output reg [15:0] immediate_out,
    output reg [15:0] branch_offset_out,

    output reg [2:0] rd_out,
    output reg [2:0] rs1_out,
    output reg [2:0] rs2_out,
    output reg [2:0] alu_sel_out,

    output reg reg_write_out,
    output reg alu_src_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg branch_out,
    output reg jump_out
);

always @(posedge clk) begin

    if (reset) begin
        pc_out <= 16'd0;
        read_data1_out <= 16'd0;
        read_data2_out <= 16'd0;
        immediate_out <= 16'd0;
        branch_offset_out <= 16'd0;

        rd_out <= 3'd0;
        rs1_out <= 3'd0;
        rs2_out <= 3'd0;
        alu_sel_out <= 3'd0;

        reg_write_out <= 1'b0;
        alu_src_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        branch_out <= 1'b0;
        jump_out <= 1'b0;
    end

    else if (flush) begin
        // Insert NOP
        pc_out <= 16'd0;
        read_data1_out <= 16'd0;
        read_data2_out <= 16'd0;
        immediate_out <= 16'd0;
        branch_offset_out <= 16'd0;

        rd_out <= 3'd0;
        rs1_out <= 3'd0;
        rs2_out <= 3'd0;
        alu_sel_out <= 3'd0;

        reg_write_out <= 1'b0;
        alu_src_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        branch_out <= 1'b0;
        jump_out <= 1'b0;
    end

    else if (stall) begin
        // Insert NOP / bubble
        pc_out <= 16'd0;
        read_data1_out <= 16'd0;
        read_data2_out <= 16'd0;
        immediate_out <= 16'd0;
        branch_offset_out <= 16'd0;

        rd_out <= 3'd0;
        rs1_out <= 3'd0;
        rs2_out <= 3'd0;
        alu_sel_out <= 3'd0;

        reg_write_out <= 1'b0;
        alu_src_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        branch_out <= 1'b0;
        jump_out <= 1'b0;
    end

    else begin
        pc_out <= pc_in;
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        immediate_out <= immediate_in;
        branch_offset_out <= branch_offset_in;

        rd_out <= rd_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        alu_sel_out <= alu_sel_in;

        reg_write_out <= reg_write_in;
        alu_src_out <= alu_src_in;
        mem_read_out <= mem_read_in;
        mem_write_out <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        branch_out <= branch_in;
        jump_out <= jump_in;
    end

end

endmodule