module tb_ALU();
    localparam vindx = 12;
    logic[31:0] a, b;
    logic[3:0] ctrl;
    logic[31:0] out, out_exp;
    logic[2:0] flags, flags_exp;
    logic[95:0] vector_in1[0 : vindx - 1];
    logic[6:0] vector_in2[0 : vindx - 1];

    ALU dut(.a(a), .b(b), .ctrl(ctrl), .out(out), .flags(flags));

    initial begin
        $readmemh("input_ALU1.txt", vector_in1);
        $readmemb("input_ALU2.txt", vector_in2);
        $dumpfile("waveform_ALU.vcd");
        $dumpvars(0, tb_ALU);
        for (integer i=0; i < vindx; i++)
        begin
            {a, b, out_exp} = vector_in1[i];
            {ctrl, flags_exp} = vector_in2[i]; #10;
            assert 
                (out === out_exp && flags === flags_exp) 
            else 
                $error("Failed at line %d : a=%h b=%h ctrl=%b out=%h flags=%b", (i+1), a, b, ctrl, out, flags);
        end
    end
endmodule
