module ALU (
    input logic[31:0] src_a,
    input logic[31:0] src_b,
    input logic[3:0] ALU_ctrl,
    output logic[31:0] ALU_result,
);
    
    logic N, Z, C, V;
    logic[31:0] sum;
    logic[31:0] shift;
    logic cout;

    always_comb begin
        prefix_adder #(5) adder (
            .a(src_a),
            .b((ALU_ctrl[0]) ? !src_b : src_b),
            .cin(ALU_ctrl[0]),
            .s(sum),
            .cout(cout)
        );

        funnel_shifter #(5) shifter (
            .upper((ALU_ctrl[2] & ALU_ctrl[1]) ? {32{src_a[31]}} : (~ALU_ctrl[2]) ? src_a : 32'b0),
            .downer((ALU_ctrl[2]) ? src_a : 32'b0),
            .shamt(src_b[4:0]),
            .direction(ALU_ctrl[2]),
            .shift(shift)
        );

        N = sum[31];
        Z = &(~sum);
        C = cout;
        V = ~(src_a[31] ^ src_b[31] ^ ALU_ctrl[0]) & (sum[31] ^ src_a[31]);

        case (ALU_ctrl)
            4'b0000 : result = sum; //add, addi, (store and load address)
            4'b0001 : result = sum; //sub
            4'b0010 : result = a & b; //and, andi
            4'b0011 : result = a | b; //or, ori
            4'b0100 : result = a ^ b; //xor, xori
            4'b0101 : result = ~C; //sltu, sltiu, bltu
            4'b0111 : result = C; //bgeu
            4'b1001 : result = N ^ V; //slt, slti, blt
            4'b1010 : result = shift; //sll, slli
            4'b1011 : result = ~(N ^ V); //bge
            4'b1100 : result = shift; //srl, srli
            4'b1101 : result = Z; //beq
            4'b1110 : result = shift; //sra, srai
            default : result = 32'bx;
        endcase
    end
endmodule
