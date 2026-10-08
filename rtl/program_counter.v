module program_counter (
    input        clk,
    input        reset,
    input  [15:0] next_pc,

    output reg [15:0] pc
);

always @(posedge clk) begin

    if (reset)
        pc <= 16'd0;
    else
        pc <= next_pc;

end

endmodule