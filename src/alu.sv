module ALU (
    input logic[31:0] src_a,
    input logic[31:0] src_b,
    input logic[3:0] ctrl,
    output logic[31:0] result,
    output logic[2:0] flags
);

    always_comb begin
        //beq(1), bne(0)
        flags[2] = (src_a == src_b) ? 1 : 0;
        //bltu(1), bgeu(0)
        flags[1] = (src_a < src_b) ? 1 : 0;
        //blt(1), bge(0)
        flags[0] = ($signed(src_a) < $signed(src_b)) ? 1 : 0;

        case (ctrl)
            //add, addi, (store and write address)
            4'b0000 : result = $signed(src_a) + $signed(src_b);
            //sub
            4'b0001 : result = $signed(src_a) - $signed(src_b);
            //and, andi
            4'b0010 : result = src_a & src_b;
            //or, ori
            4'b0011 : result = src_a | src_b;
            //xori
            4'b0100 : result = src_a ^ src_b;
            //sll, slli
            4'b0101 : result = src_a << src_b[4:0];
            //srl, srli
            4'b0110 : result = src_a >> src_b[4:0];
            //sra, srai
            4'b0111 : result = $signed(src_a) >>> src_b[4:0];
            //slt, slti
            4'b1000 : result = ($signed(src_a) < $signed(src_b)) ? 1 : 0;
            //sltu, sltui
            4'b1001 : result = ($unsigned(src_a) < $unsigned(src_b)) ? 1 : 0;
            //ALU Error
            default : result = 32'bx;
        endcase
    end
endmodule
