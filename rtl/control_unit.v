module control_unit (
    input  [3:0] opcode,

    output reg [2:0] ALU_Sel,
    output reg       RegWrite,
    output reg       ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,
    output reg Branch,
    output reg Jump
);

always @(*) begin

    // Default values
    ALU_Sel  = 3'b000;
    RegWrite = 1'b0;
    ALUSrc   = 1'b0;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    MemToReg = 1'b0;
    Branch   = 1'b0;
    Jump     = 1'b0;
    case (opcode)

        // ADD
        4'b0000: begin
            ALU_Sel = 3'b000;
            RegWrite = 1'b1;
        end

        // SUB
        4'b0001: begin
            ALU_Sel = 3'b001;
            RegWrite = 1'b1;
        end

        // AND
        4'b0010: begin
            ALU_Sel = 3'b010;
            RegWrite = 1'b1;
        end

        // OR
        4'b0011: begin
            ALU_Sel = 3'b011;
            RegWrite = 1'b1;
        end

        // XOR
        4'b0100: begin
            ALU_Sel = 3'b100;
            RegWrite = 1'b1;
        end

        // ADDI
         4'b0110: begin
            ALU_Sel = 3'b000;
            RegWrite = 1'b1;
            ALUSrc = 1'b1;
        end
         
        // LD
        4'b0111: begin
            ALU_Sel  = 3'b000;
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            MemRead  = 1'b1;
            MemWrite = 1'b0;
            MemToReg = 1'b1;
        end

        // ST
        4'b1000: begin
            ALU_Sel  = 3'b000;
            RegWrite = 1'b0;
            ALUSrc   = 1'b1;
            MemRead  = 1'b0;
            MemWrite = 1'b1;
            MemToReg = 1'b0;
        end   

        // BEQ
        4'b1001: begin
            ALU_Sel  = 3'b001;   // SUB
            RegWrite = 1'b0;
            ALUSrc   = 1'b0;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            Branch   = 1'b1;
            Jump     = 1'b0;
        end   

        // JMP
        4'b1010: begin
            ALU_Sel  = 3'b000;
            RegWrite = 1'b0;
            ALUSrc   = 1'b0;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            Branch   = 1'b0;
            Jump     = 1'b1;
        end
        4'b0101: begin
            ALU_Sel  = 3'b000;
            RegWrite = 1'b0;
            ALUSrc   = 1'b0;
            MemRead  = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            Branch   = 1'b0;
            Jump     = 1'b0;
        end

        // Anything else
        default: begin
            ALU_Sel = 3'b000;
            RegWrite = 1'b0;
        end

    endcase

end

endmodule