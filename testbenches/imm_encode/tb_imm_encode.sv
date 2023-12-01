module tb_imm_encode();
    localparam vindx = 8;
    logic[31:7] instr;
    logic[2:0] instr_type;
    logic[31:0] imm, imm_exp;
    logic[63:0] vector_words[0 : vindx - 1];
    logic[2:0] vector_control[0 : vindx - 1];

    imm_encode dut(.instr(instr), .instr_type(instr_type), .imm(imm));

    logic[6:0] opcode;

    initial begin
        $readmemh("input_imm_encode_words.txt", vector_words);
        $readmemb("input_imm_encode_control.txt", vector_control);
        $dumpfile("waveform_imm_encode.vcd");
        $dumpvars(0, tb_imm_encode);
        for (integer i=0; i < vindx; i++)
        begin
            #10;
            {instr, opcode, imm_exp} = vector_words[i];
            instr_type = vector_control[i];
            assert 
                (imm === imm_exp) 
            else 
                $error("Failed at line %d : instr=%h, imm=%h, type=%b", (i+1), instr, imm, instr_type);
        end
        $finish;
    end
endmodule
