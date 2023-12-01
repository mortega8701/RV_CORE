module control_unit (
    input logic[6:0] op,
    input logic[2:0] funct3,
    input logic[6:0] funct7,
    input logic[2:0] flags,
    output logic pc_src,
    output logic[2:0] instr_type,
    output logic write_reg,
    output logic pc_alu_src,
    output logic imm_src,
    output logic[3:0] alu_ctrl,
    output logic branch_src,
    output logic data_op_src,
    output logic write_mem,
    output logic[2:0] mem_op,
    output logic result_src
);

    logic[16:0] instr_opcode;
    logic[17:0] control_out;

    assign instr_opcode = {funct7, funct3, op};
    assign {pc_src, instr_type, write_reg, pc_alu_src, 
           imm_src, alu_ctrl, branch_src, data_op_src, 
           write_mem, mem_op, result_src} = control_out;

    always_comb begin
        casez (instr_opcode)
            //loads
            17'b???????_000_0000011 : control_out = 18'b000_0_1_0_1_0000_0_x_0_000_1; //lb
            17'b???????_001_0000011 : control_out = 18'b000_0_1_0_1_0000_0_x_0_001_1; //lh
            17'b???????_010_0000011 : control_out = 18'b000_0_1_0_1_0000_0_x_0_010_1; //lw
            17'b???????_100_0000011 : control_out = 18'b000_0_1_0_1_0000_0_x_0_100_1; //lbu
            17'b???????_101_0000011 : control_out = 18'b000_0_1_0_1_0000_0_x_0_101_1; //lhu
            //alu_imm_ops
            17'b???????_000_0010011 : control_out = 18'b000_0_1_0_1_0000_0_1_0_xxx_0; //addi
            17'b0000000_001_0010011 : control_out = 18'b000_0_1_0_1_0101_0_1_0_xxx_0; //slli
            17'b???????_010_0010011 : control_out = 18'b000_0_1_0_1_1000_0_1_0_xxx_0; //slti
            17'b???????_011_0010011 : control_out = 18'b000_0_1_0_1_1001_0_1_0_xxx_0; //sltui
            17'b???????_100_0010011 : control_out = 18'b000_0_1_0_1_0100_0_1_0_xxx_0; //xori
            17'b0000000_101_0010011 : control_out = 18'b000_0_1_0_1_0110_0_1_0_xxx_0; //srli
            17'b0100000_101_0010011 : control_out = 18'b000_0_1_0_1_0111_0_1_0_xxx_0; //srai
            17'b???????_110_0010011 : control_out = 18'b000_0_1_0_1_0011_0_1_0_xxx_0; //ori
            17'b???????_111_0010011 : control_out = 18'b000_0_1_0_1_0010_0_1_0_xxx_0; //andi
            //pc_to_write
            17'b???????_???_0010111 : control_out = 18'b011_0_1_1_1_0000_0_1_0_xxx_0; //auipc
            //store
            17'b???????_000_0100011 : control_out = 18'b001_0_0_0_1_0000_0_x_1_000_x; //sb
            17'b???????_001_0100011 : control_out = 18'b001_0_0_0_1_0000_0_x_1_001_x; //sh
            17'b???????_010_0100011 : control_out = 18'b001_0_0_0_1_0000_0_x_1_010_x; //sw
            //alu_reg_ops
            17'b0000000_000_0010011 : control_out = 18'b000_0_1_0_0_0000_0_1_0_xxx_0; //add
            17'b0100000_000_0010011 : control_out = 18'b000_0_1_0_0_0001_0_1_0_xxx_0; //sub
            17'b0000000_001_0010011 : control_out = 18'b000_0_1_0_0_0101_0_1_0_xxx_0; //sll
            17'b0000000_010_0010011 : control_out = 18'b000_0_1_0_0_1000_0_1_0_xxx_0; //slt
            17'b0000000_011_0010011 : control_out = 18'b000_0_1_0_0_1001_0_1_0_xxx_0; //sltu
            17'b0000000_100_0010011 : control_out = 18'b000_0_1_0_0_0100_0_1_0_xxx_0; //xor
            17'b0000000_101_0010011 : control_out = 18'b000_0_1_0_0_0110_0_1_0_xxx_0; //srl
            17'b0100000_101_0010011 : control_out = 18'b000_0_1_0_0_0111_0_1_0_xxx_0; //sra
            17'b0000000_110_0010011 : control_out = 18'b000_0_1_0_0_0011_0_1_0_xxx_0; //or
            17'b0000000_111_0010011 : control_out = 18'b000_0_1_0_0_0010_0_1_0_xxx_0; //and
            //load_imm
            17'b???????_???_0110111 : control_out = 18'b011_0_1_0_1_1010_0_1_0_xxx_0; //lui
            //branches
            17'b???????_000_1100011 : control_out = (flags[2] == 1'b1) ? //beq
                                                    18'b010_1_0_0_1_xxxx_1_x_0_xxx_x : 
                                                    18'b010_1_0_0_1_xxxx_0_x_0_xxx_x;
            17'b???????_001_1100011 : control_out = (flags[2] == 1'b0) ? //bne
                                                    18'b010_1_0_0_1_xxxx_1_x_0_xxx_x : 
                                                    18'b010_1_0_0_1_xxxx_0_x_0_xxx_x;
            17'b???????_100_1100011 : control_out = (flags[0] == 1'b1) ? //blt
                                                    18'b010_1_0_0_1_xxxx_1_x_0_xxx_x : 
                                                    18'b010_1_0_0_1_xxxx_0_x_0_xxx_x;
            17'b???????_101_1100011 : control_out = (flags[0] == 1'b0) ? //bge
                                                    18'b010_1_0_0_1_xxxx_1_x_0_xxx_x : 
                                                    18'b010_1_0_0_1_xxxx_0_x_0_xxx_x;
            17'b???????_110_1100011 : control_out = (flags[1] == 1'b1) ? //bltu
                                                    18'b010_1_0_0_1_xxxx_1_x_0_xxx_x : 
                                                    18'b010_1_0_0_1_xxxx_0_x_0_xxx_x;
            17'b???????_111_1100011 : control_out = (flags[1] == 1'b0) ? //bgeu
                                                    18'b010_1_0_0_1_xxxx_1_x_0_xxx_x : 
                                                    18'b010_1_0_0_1_xxxx_0_x_0_xxx_x;
            //jump_link_reg
            17'b???????_000_1100111 : control_out = 18'b000_1_1_0_1_0000_1_0_0_xxx_0; //jalr
            //jump
            17'b???????_000_1100111 : control_out = 18'b100_1_1_0_1_0000_1_0_0_xxx_0; //jalr
            default : control_out = 18'bxxx_x_x_x_x_xxxx_x_x_x_xxx_x;
        endcase
    end
endmodule
