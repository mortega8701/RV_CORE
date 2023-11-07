module control_unit (
    input logic[6:0] op,
    input logic[2:0] funct3,
    input logic[6:0] funct7,
    input logic[2:0] flags,
    output logic[2:0] instr_type,
    output logic write_reg,
    output logic add_PC,
    output logic imm_src,
    output logic[3:0] ALU_ctrl,
    output logic branch_src,
    output logic data_op_src,
    output logic write_mem,
    output logic result_src,
    output logic[2:0] load_type,
    output logic[1:0] store_type,
    output logic PC_src
);

    always_comb begin
        case (op)
            //LOAD TYPE
            7'b0000011 : begin
                PC_src = 1'b0;
                write_reg = 1'b1;
                add_PC = 1'b0;
                imm_src = 1'b1;
                ALU_src = 4'b0000;
                branch_src = 1'b0;
                write_mem = 1'b0;
                case (funct3)
                    3'b000 : load_type = 3'b100; //lb
                    3'b001 : load_type = 3'b101; //lh
                    3'b010 : load_type = 3'b110; //lw
                    3'b100 : load_type = 3'b001; //lhu
                    3'b101 : load_type = 3'b000; //lbu
                endcase
                result_src = 1'b1;
            end
            //IMMEDIATE ALU OPERATIONS
            7'b0010011 : begin
                PC_src = 1'b0;
                write_reg = 1'b1;
                add_PC = 1'b0;
                imm_src = 1'b1;
                case (funct3)
                    3'b000 : ALU_ctrl = 4'b0000; //addi
                    3'b001 : ALU_ctrl = 4'b0001; //slli
                    3'b010 : ALU_ctrl = 4'b1001; //slti
                    3'b011 : ALU_ctrl = 4'b1010; //sltui
                    3'b100 : ALU_ctrl = 4'b0100; //xori
                    3'b101 : ALU_crtl = (funct7[5]) ? 
                                        4'b0111 : //srli
                                        4'b0110; //srai
                    3'b110 : ALU_ctrl = 4'b0011; //ori
                    3'b111 : ALU_ctrl = 4'b0010: //andi
                endcase
                branch_src = 1'b0;
                data_op_src = 1'b1;
                write_mem = 1'b0;
                result_src= 1'b0;
            end
            //auipc
            7'b0010111 : begin

            end
            //STORE
            7'b0100011 : begin
                
            end
        endcase
    end
endmodule
