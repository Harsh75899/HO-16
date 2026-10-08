module forwarding_unit (
    input ex_mem_reg_write, input ex_mem_mem_to_reg, input [2:0] ex_mem_rd,
    input mem_wb_reg_write, input [2:0] mem_wb_rd,
    input [2:0] id_ex_rs1, input [2:0] id_ex_rs2, input [2:0] id_ex_rd,
    input id_ex_mem_write,
    output reg [1:0] forward_a, output reg [1:0] forward_b, output reg [1:0] forward_store
);
always @(*) begin
    forward_a=2'b00; forward_b=2'b00; forward_store=2'b00;
    if (ex_mem_reg_write && !ex_mem_mem_to_reg && ex_mem_rd!=3'd0 && ex_mem_rd==id_ex_rs1) forward_a=2'b01;
    else if (mem_wb_reg_write && mem_wb_rd!=3'd0 && mem_wb_rd==id_ex_rs1) forward_a=2'b10;
    if (ex_mem_reg_write && !ex_mem_mem_to_reg && ex_mem_rd!=3'd0 && ex_mem_rd==id_ex_rs2) forward_b=2'b01;
    else if (mem_wb_reg_write && mem_wb_rd!=3'd0 && mem_wb_rd==id_ex_rs2) forward_b=2'b10;
    if (id_ex_mem_write && ex_mem_reg_write && !ex_mem_mem_to_reg && ex_mem_rd!=3'd0 && ex_mem_rd==id_ex_rd) forward_store=2'b01;
    else if (id_ex_mem_write && mem_wb_reg_write && mem_wb_rd!=3'd0 && mem_wb_rd==id_ex_rd) forward_store=2'b10;
end
endmodule
