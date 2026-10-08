module ho16_pipeline (
    input clk,
    input reset,
    output [15:0] debug_pc,
    output [15:0] debug_instruction
);
    // =========================================
    // GLOBAL / IF SIGNALS
    // =========================================
    wire [15:0] pc;
    wire [15:0] instruction;
    assign debug_pc = pc;
    assign debug_instruction = instruction;
    wire [15:0] next_pc;
    // =========================================
    // ID SIGNALS
    // =========================================
    wire [3:0] opcode;
    wire [2:0] rd;
    wire [2:0] rs1;
    wire [2:0] rs2;
    wire stall;
    wire flush;
    wire uses_src1;
    wire uses_src2;
    // =========================================
    // EX SIGNALS
    // =========================================
    wire [1:0] forward_a;
    wire [1:0] forward_b;
    wire [15:0] ex_pc;
    wire [15:0] ex_read_data1;
    wire [15:0] ex_read_data2;
    wire [15:0] ex_immediate;
    wire [15:0] ex_branch_offset;
    wire [2:0] ex_rd;
    wire [2:0] ex_rs1;
    wire [2:0] ex_rs2;
    wire [2:0] ex_alu_sel;
    wire ex_reg_write;
    wire ex_alu_src;
    wire ex_mem_read;
    wire ex_mem_write;
    wire ex_mem_to_reg;
    wire ex_branch;
    wire ex_jump;
    wire [15:0] alu_b;
    wire [15:0] ex_alu_result;
    wire ex_zero;
    wire branch_equal;
    // =========================================
    // EX/MEM SIGNALS
    // =========================================
    wire [15:0] mem_alu_result;
    wire [15:0] mem_write_data;
    wire [2:0]  mem_rd;
    wire mem_reg_write;
    wire mem_mem_read;
    wire mem_mem_write;
    wire mem_mem_to_reg;
    wire [15:0] wb_alu_result;
    wire [15:0] wb_read_data;
    wire [2:0]  wb_rd;
    wire        wb_reg_write;
    wire        wb_mem_to_reg;
    // =========================================
    // MEMORY / WRITEBACK SIGNALS
    // =========================================
    wire [15:0] mem_read_data;
    wire [15:0] writeback_data;
    // =========================================
    // BRANCH / JUMP CONTROL
    // =========================================
    wire branch_taken;
    wire [15:0] branch_target;
    wire [15:0] jump_target;
    assign branch_taken = ex_branch && branch_equal;
    assign branch_target = ex_pc + ex_branch_offset;
    assign jump_target   = ex_pc + ex_branch_offset;
    assign flush = ex_jump || branch_taken;
    // =========================================
    // SOURCE REGISTER USAGE
    // =========================================
    assign uses_src1 =
        (opcode == 4'b0000) ||   // ADD
        (opcode == 4'b0001) ||   // SUB
        (opcode == 4'b0010) ||   // AND
        (opcode == 4'b0011) ||   // OR
        (opcode == 4'b0100) ||   // XOR
        (opcode == 4'b0110) ||   // ADDI
        (opcode == 4'b0111) ||   // LD
        (opcode == 4'b1000) ||   // ST
        (opcode == 4'b1001);     // BEQ
    assign uses_src2 =
        (opcode == 4'b0000) ||   // ADD
        (opcode == 4'b0001) ||   // SUB
        (opcode == 4'b0010) ||   // AND
        (opcode == 4'b0011) ||   // OR
        (opcode == 4'b0100) ||   // XOR
        (opcode == 4'b1000) ||   // ST
        (opcode == 4'b1001);     // BEQ
    wire [15:0] store_data_forwarded;
    assign store_data_forwarded =
        (forward_b == 2'b01) ? mem_alu_result :
        (forward_b == 2'b10) ? writeback_data :
        ex_read_data2;
    // =========================================
    // IF STAGE
    // =========================================
    fetch_unit fetch (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc),
        .instruction(instruction)
    );
    assign next_pc =
        stall ? pc :
        ex_jump ? jump_target :
        branch_taken ? branch_target :
        pc + 16'd1;
    // =========================================
    // IF/ID PIPELINE REGISTER
    // =========================================
    wire [15:0] id_pc;
    wire [15:0] id_instruction;
    if_id_register if_id (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .pc_in(pc),
        .instruction_in(instruction),
        .pc_out(id_pc),
        .instruction_out(id_instruction)
    );
    // =========================================
    // ID STAGE
    // =========================================
    wire [5:0] immediate;
    instruction_decoder decoder (
        .instruction(id_instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .immediate(immediate)
    );
    // =========================================
    // REGISTER FILE
    // =========================================
    wire [15:0] read_data1;
    wire [15:0] read_data2;
    wire [2:0] read_addr2;
    // ST uses RD as the second source register.
    assign read_addr2 =
        (opcode == 4'b1000) ? rd : rs2;
    register_file rf (
        .clk(clk),
        .ReadAddr1(rs1),
        .ReadAddr2(read_addr2),
        .ReadData1(read_data1),
        .ReadData2(read_data2),
        .RegWrite(wb_reg_write),
        .WriteAddr(wb_rd),
        .WriteData(writeback_data)
    );
    // =========================================
    // CONTROL UNIT
    // =========================================
    wire [2:0] alu_sel;
    wire reg_write;
    wire alu_src;
    wire mem_read;
    wire mem_write;
    wire mem_to_reg;
    wire branch;
    wire jump;
    control_unit control (
        .opcode(opcode),
        .ALU_Sel(alu_sel),
        .RegWrite(reg_write),
        .ALUSrc(alu_src),
        .MemRead(mem_read),
        .MemWrite(mem_write),
        .MemToReg(mem_to_reg),
        .Branch(branch),
        .Jump(jump)
    );
    // =========================================
    // IMMEDIATE EXTENSION
    // =========================================
    wire [15:0] immediate_extended;
    wire [15:0] branch_offset;
    assign branch_offset =
        {{13{id_instruction[2]}}, id_instruction[2:0]};
    assign immediate_extended =
        {{10{immediate[5]}}, immediate};
    // =========================================
    // ID/EX PIPELINE REGISTER
    // =========================================
    id_ex_register id_ex (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .pc_in(id_pc),
        .read_data1_in(read_data1),
        .read_data2_in(read_data2),
        .immediate_in(immediate_extended),
        .branch_offset_in(branch_offset),
        .rd_in(rd),
        .rs1_in(rs1),
        .rs2_in(rs2),
        .alu_sel_in(alu_sel),
        .reg_write_in(reg_write),
        .alu_src_in(alu_src),
        .mem_read_in(mem_read),
        .mem_write_in(mem_write),
        .mem_to_reg_in(mem_to_reg),
        .branch_in(branch),
        .jump_in(jump),
        .pc_out(ex_pc),
        .read_data1_out(ex_read_data1),
        .read_data2_out(ex_read_data2),
        .immediate_out(ex_immediate),
        .branch_offset_out(ex_branch_offset),
        .rd_out(ex_rd),
        .rs1_out(ex_rs1),
        .rs2_out(ex_rs2),
        .alu_sel_out(ex_alu_sel),
        .reg_write_out(ex_reg_write),
        .alu_src_out(ex_alu_src),
        .mem_read_out(ex_mem_read),
        .mem_write_out(ex_mem_write),
        .mem_to_reg_out(ex_mem_to_reg),
        .branch_out(ex_branch),
        .jump_out(ex_jump)
    );
    // =========================================
    // EX STAGE - ALU
    // =========================================
    wire [15:0] alu_a_forwarded;
    wire [15:0] alu_b_forwarded;
    assign alu_a_forwarded =
        (forward_a == 2'b01) ? mem_alu_result :
        (forward_a == 2'b10) ? writeback_data :
        ex_read_data1;
    assign alu_b_forwarded =
        (forward_b == 2'b01) ? mem_alu_result :
        (forward_b == 2'b10) ? writeback_data :
        ex_read_data2;
    assign alu_b =
        ex_alu_src ? ex_immediate :
        alu_b_forwarded;
    assign branch_equal = (alu_a_forwarded == alu_b_forwarded);
    alu alu_unit (
        .A(alu_a_forwarded),
        .B(alu_b),
        .ALU_Sel(ex_alu_sel),
        .Result(ex_alu_result),
        .Zero(ex_zero)
    );
    // =========================================
    // EX/MEM PIPELINE REGISTER
    // =========================================
    ex_mem_register ex_mem (
        .clk(clk),
        .reset(reset),
        .alu_result_in(ex_alu_result),
        .read_data2_in(store_data_forwarded),
        .rd_in(ex_rd),
        .reg_write_in(ex_reg_write),
        .mem_read_in(ex_mem_read),
        .mem_write_in(ex_mem_write),
        .mem_to_reg_in(ex_mem_to_reg),
        .alu_result_out(mem_alu_result),
        .read_data2_out(mem_write_data),
        .rd_out(mem_rd),
        .reg_write_out(mem_reg_write),
        .mem_read_out(mem_mem_read),
        .mem_write_out(mem_mem_write),
        .mem_to_reg_out(mem_mem_to_reg)
    );
    // =========================================
    // DATA MEMORY
    // =========================================
    data_memory data_mem (
        .clk(clk),
        .MemRead(mem_mem_read),
        .MemWrite(mem_mem_write),
        .address(mem_alu_result),
        .WriteData(mem_write_data),
        .ReadData(mem_read_data)
    );
    mem_wb_register mem_wb (
        .clk(clk),
        .reset(reset),
        .alu_result_in(mem_alu_result),
        .read_data_in(mem_read_data),
        .rd_in(mem_rd),
        .reg_write_in(mem_reg_write),
        .mem_to_reg_in(mem_mem_to_reg),
        .alu_result_out(wb_alu_result),
        .read_data_out(wb_read_data),
        .rd_out(wb_rd),
        .reg_write_out(wb_reg_write),
        .mem_to_reg_out(wb_mem_to_reg)
    );
    // =========================================
    // WRITEBACK STAGE
    // =========================================
    assign writeback_data =
        wb_mem_to_reg ? wb_read_data : wb_alu_result;
    // =========================================
    // HAZARD DETECTION
    // =========================================
    hazard_unit hazard (
        .id_ex_reg_write(ex_reg_write),
        .id_ex_mem_to_reg(ex_mem_to_reg),
        .id_ex_rd(ex_rd),
        .ex_mem_reg_write(mem_reg_write),
        .ex_mem_rd(mem_rd),
        .if_id_src1(rs1),
        .if_id_src2(read_addr2),
        .uses_src1(uses_src1),
        .uses_src2(uses_src2),
        .stall(stall)
    );
    forwarding_unit forwarding (
        .ex_mem_reg_write(mem_reg_write),
        .ex_mem_mem_to_reg(mem_mem_to_reg),
        .ex_mem_rd(mem_rd),
        .mem_wb_reg_write(wb_reg_write),
        .mem_wb_rd(wb_rd),
        .id_ex_rs1(ex_rs1),
        .id_ex_rs2(ex_mem_write ? ex_rd : ex_rs2),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );
endmodule