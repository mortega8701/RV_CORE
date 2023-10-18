module ALU (
    input logic[31:0] src_a, src_b,
    input logic[4:0] ALU_ctrl,
    output logic[31:0] ALU_result
);

    always_comb begin
        case (ALU_ctrl)
            //add, addi, (all address calculations)
            3'b000 : alu_result = src_a + src_b;
            //sub
            3'b001 : alu_result = src_a - src_b;
            //and, andi
            3'b010 : alu_result = src_a & src_b;
            //or, ori
            3'b011 : alu_result = src_a | src_b;
            //xor, xori
            3'b100 : alu_result = src_a ^ src_b;
            //sll, slli
            3'b101 : alu_result = src_a << src_b[4:0];
            //srl, srli
            3'b110 : alu_result = src_a >> src_b[4:0];
            //sra, srai
            3'b111 : alu_result = src_a >>> src_b[4:0];
            //
            default : alu_result = 32'bx;
        endcase
    end
endmodule
