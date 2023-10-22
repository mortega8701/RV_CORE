module tb_imm_encode();
    localparam vindx = 8;
    logic[31:0] instr;
    logic[2:0] instr_type;
    logic[31:0] imm, imm_exp;
    logic[66:0] vector_in[0 : vindx - 1];

    imm_encode dut(.instr(instr), .instr_type(instr_type), .imm(imm));

    initial begin
        $readmemh("input_imm_encode.txt", vector_in);
        $dumpfile("waveform_imm_encode.vcd");
        $dumpvars(0, tb_imm_encode);
        for (integer i=0; i < vindx; i++)
        begin
            {instr_type, instr, imm_exp} = vector_in[i]; #10;
            assert 
                (imm === imm_exp) 
            else 
                $error("Failed at line %d : instr=%h, imm=%h, type=%b", (i+1), instr, imm, instr_type);
        end
    end
endmodule
