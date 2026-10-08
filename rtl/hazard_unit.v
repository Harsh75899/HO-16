module hazard_unit (
    input        id_ex_reg_write,
    input        id_ex_mem_to_reg,
    input  [2:0] id_ex_rd,

    input        ex_mem_reg_write,
    input  [2:0] ex_mem_rd,

    input  [2:0] if_id_src1,
    input  [2:0] if_id_src2,

    input        uses_src1,
    input        uses_src2,

    output       stall
);

wire hazard_src1;
wire hazard_src2;

assign hazard_src1 =
    uses_src1 &&
    id_ex_reg_write &&
    id_ex_mem_to_reg &&
    (id_ex_rd != 3'd0) &&
    (id_ex_rd == if_id_src1);

assign hazard_src2 =
    uses_src2 &&
    id_ex_reg_write &&
    id_ex_mem_to_reg &&
    (id_ex_rd != 3'd0) &&
    (id_ex_rd == if_id_src2);

assign stall =
    hazard_src1 ||
    hazard_src2;

endmodule