module imm_encode(
    input logic[31:0] instr,
    input logic[2:0] instr_type,
    output logic[31:0] imm
);

    always_comb begin
        case(instr_type)
            0 : imm = {20{instr[31]}, instr[31:20]}; //I-Instr
            1 : imm = {20{instr[31]}, instr[31:25], instr[11:7]}; //S-instr
            2 : imm = {20{instr[31]}, instr[7], instr[30:25], instr[11:8], 1'b0}; //B-instr
            3 : imm = {instr[31:12], 12'b0}; //U-instr
            4 : imm = {12{instr[31]}, instr[19:12], instr[20], instr[30:21], 1'b0}; //J-instr
            default : imm = 32'bx;
        endcase
    end
endmodule
