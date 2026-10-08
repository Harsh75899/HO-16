module mem_wb_register (
    input clk,
    input reset,

    input [15:0] alu_result_in,
    input [15:0] read_data_in,
    input [2:0]  rd_in,

    input reg_write_in,
    input mem_to_reg_in,

    output reg [15:0] alu_result_out,
    output reg [15:0] read_data_out,
    output reg [2:0]  rd_out,

    output reg reg_write_out,
    output reg mem_to_reg_out
);

always @(posedge clk) begin
    if (reset) begin
        alu_result_out <= 16'd0;
        read_data_out  <= 16'd0;
        rd_out         <= 3'd0;
        reg_write_out  <= 1'b0;
        mem_to_reg_out <= 1'b0;
    end
    else begin
        alu_result_out <= alu_result_in;
        read_data_out  <= read_data_in;
        rd_out         <= rd_in;
        reg_write_out  <= reg_write_in;
        mem_to_reg_out <= mem_to_reg_in;
    end
end

endmodule