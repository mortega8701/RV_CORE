module tb_alu();
    localparam vindx = 12;
    logic[31:0] a, b;
    logic[3:0] ctrl;
    logic[31:0] out, out_exp;
    logic[2:0] flags, flags_exp;
    logic[95:0] vector_words[0 : vindx - 1];
    logic[6:0] vector_control[0 : vindx - 1];

    alu dut(.a(a), .b(b), .ctrl(ctrl), .out(out), .flags(flags));

    initial begin
        $readmemh("input_alu_words.txt", vector_words);
        $readmemb("input_alu_control", vector_control);
        $dumpfile("waveform_alu.vcd");
        $dumpvars(0, tb_alu);
        for (integer i=0; i < vindx; i++)
        begin
            #10;
            {a, b, out_exp} = vector_words[i];
            {ctrl, flags_exp} = vector_control[i];
            assert 
                (out === out_exp && flags === flags_exp) 
            else 
                $error("Failed at line %d : a=%h b=%h ctrl=%b out=%h flags=%b", (i+1), a, b, ctrl, out, flags);
        end
        $finish;
    end
endmodule
