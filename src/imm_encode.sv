module imm_encode(
    input logic[31:7] instr,
    input logic[2:0] instr_type,
    output logic[31:0] imm
);

    always_comb begin
        case(instr_type)
            //I-Instr
            3'b000 : imm = {{20{instr[31]}}, instr[31:20]};
            //S-Instr
            3'b001 : imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            //B-Instr
            3'b010 : imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            //U-Instr
            3'b011 : imm = {instr[31:12], 12'b0};
            //J-Instr
            3'b100 : imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            //Encode Error
            default : imm = 32'bx;
        endcase
    end
endmodule
