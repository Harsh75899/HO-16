module alu (
    input  [15:0] A,
    input  [15:0] B,
    input  [2:0]  ALU_Sel,
    output reg [15:0] Result,
    output reg        Zero
);

always @(*) begin

    case (ALU_Sel)

        3'b000: Result = A + B;   // ADD
        3'b001: Result = A - B;   // SUB
        3'b010: Result = A & B;   // AND
        3'b011: Result = A | B;   // OR
        3'b100: Result = A ^ B;   // XOR

        default: Result = 16'b0;

    endcase

    if (Result == 16'b0)
        Zero = 1'b1;
    else
        Zero = 1'b0;

end

endmodule