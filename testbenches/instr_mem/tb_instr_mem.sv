module tb_instr_mem();
    localparam vindx = 6;
    logic[31:0] a;
    logic[31:0] rd, rd_exp;
    logic[63:0] vector_in[0 : vindx - 1];

    instr_mem dut(.a(a), .rd(rd));

    initial begin
        $readmemh("input_instr_mem.txt", vector_in);
        $dumpfile("waveform_instr_mem.vcd");
        $dumpvars(0, tb_instr_mem);
        for (integer i=0; i < vindx; i++)
        begin
            {a, rd_exp} = vector_in[i]; #10;
            assert 
                (rd === rd_exp) 
            else 
                $error("Failed at line %d : a=%h, rd=%h", (i+1), a, rd);
        end
    end
endmodule
