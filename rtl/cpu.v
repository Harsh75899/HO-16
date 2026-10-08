module cpu (
    input  [15:0] instruction,
    input         clk,

    output        Branch,
    output        Zero,
    output        Jump,
    output [15:0] ImmediateValue,
    output [15:0] BranchOffset
);
    assign BranchOffset = {{13{instruction[2]}}, instruction[2:0]};
    // -------------------------
    // Decoder signals
    // -------------------------

    wire [3:0] opcode;
    wire [2:0] rd;
    wire [2:0] rs1;
    wire [2:0] rs2;
    wire [5:0] immediate;


    // -------------------------
    // Control signals
    // -------------------------

    wire [2:0] ALU_Sel;
    wire       RegWrite;
    wire       ALUSrc;


    // -------------------------
    // Register File signals
    // -------------------------

    wire [15:0] ReadData1;
    wire [15:0] ReadData2;

    wire [15:0] WriteData;

    assign ImmediateValue = {{10{immediate[5]}}, immediate};


    // -------------------------
    // ALU signals
    // -------------------------

    wire [15:0] ALU_Result;
    wire        ALU_Zero;
    assign Zero = ALU_Zero;
    wire [15:0] MemoryReadData;
    wire [15:0] ALU_B;
    assign ALU_B = ALUSrc ? ImmediateValue : ReadData2;
    wire       MemRead;
    wire       MemWrite;
    wire       MemToReg;


    // -------------------------
    // Instruction Decoder
    // -------------------------

    instruction_decoder decoder (
        .instruction(instruction),

        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .immediate(immediate)
    );


    // -------------------------
    // Control Unit
    // -------------------------
    control_unit control (
    .opcode(opcode),

    .ALU_Sel(ALU_Sel),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemToReg(MemToReg),
    .Branch(Branch),
    .Jump(Jump)
    );

    // -------------------------
    // Register File
    // -------------------------
    wire [2:0] ReadAddr2;

    assign ReadAddr2 = (opcode == 4'b1000) ? rd : rs2;

    register_file rf (
    .clk(clk),

    .ReadAddr1(rs1),
    .ReadAddr2(ReadAddr2),

    .ReadData1(ReadData1),
    .ReadData2(ReadData2),

    .RegWrite(RegWrite),
    .WriteAddr(rd),
    .WriteData(WriteData)
   );


    // -------------------------
    // ALU
    // -------------------------

    alu alu_unit (
    .A(ReadData1),
    .B(ALU_B),

    .ALU_Sel(ALU_Sel),

    .Result(ALU_Result),
    .Zero(ALU_Zero)
    );
    data_memory data_mem (
    .clk(clk),

    .MemRead(MemRead),
    .MemWrite(MemWrite),

    .address(ALU_Result),
    .WriteData(ReadData2),

    .ReadData(MemoryReadData)
   );


    // ALU result goes back
    // into the register file

    assign WriteData = MemToReg ? MemoryReadData : ALU_Result;

endmodule