module tb_ALU();
    localparam vindx = 16;
    logic[31:0] src_a, src_b;
    logic[3:0] ctrl;
    logic[31:0] result, result_exp;
    logic[2:0] flags, flags_exp;
    logic[95:0] vector_in1[0 : vindx - 1];
    logic[6:0] vector_in2[0 : vindx - 1];

    ALU dut(.src_a(src_a), .src_b(src_b), .ctrl(ctrl), .result(result), .flags(flags));

    initial begin
        $readmemh("input_ALU1.txt", vector_in1);
        $readmemb("input_ALU2.txt", vector_in2);
        $dumpfile("waveform_ALU.vcd");
        $dumpvars(0, tb_ALU);
        for (integer i=0; i < vindx; i++)
        begin
            {src_a, src_b, result_exp} = vector_in1[i];
            {ctrl, flags_exp} = vector_in2[i]; #10;
            assert 
                (result === result_exp && flags === flags_exp) 
            else 
                $error("Failed at line %d : src_a=%h src_b=%h ctrl=%b result=%h flags=%b", (i+1), src_a, src_b, ctrl, result, flags);
        end
    end
endmodule
