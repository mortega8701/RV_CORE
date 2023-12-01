module alu (
    input logic signed[31:0] a,
    input logic signed[31:0] b,
    input logic[3:0] ctrl,
    output logic signed[31:0] out,
    output logic[2:0] flags
);

    always_comb begin
        //beq(1), bne(0)
        flags[2] = (a == b) ? 1'b1 : 1'b0;
        //blt(1), bge(0)
        flags[1] = (a < b) ? 1'b1 : 1'b0;
        //bltu(1), bgeu(0)
        flags[0] = ($unsigned(a) < $unsigned(b)) ? 1 : 0;

        case (ctrl)
            //add, addi, auipc, store/write address
            4'b0000 : out = a + b;
            //sub
            4'b0001 : out = a - b;
            //and, andi
            4'b0010 : out = a & b;
            //or, ori
            4'b0011 : out = a | b;
            //xor, xori
            4'b0100 : out = a ^ b;
            //sll, slli
            4'b0101 : out = a << b[4:0];
            //srl, srli
            4'b0110 : out = a >> b[4:0];
            //sra, srai
            4'b0111 : out = a >>> b[4:0];
            //slt, slti
            4'b1000 : out = (a < b) ? 1 : 0;
            //sltu, sltui
            4'b1001 : out = ($unsigned(a) < $unsigned(b)) ? 1 : 0;
            //lui (buff)
            4'b1010 : out = b;
            //ALU Error
            default : out = 32'bx;
        endcase
    end
endmodule
