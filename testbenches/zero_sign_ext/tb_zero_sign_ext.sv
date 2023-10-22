module tb_zero_sign_ext();
    localparam vindx = 5;
    logic[31:0] data;
    logic[2:0] sel;
    logic[31:0] trimm, trimm_exp;
    logic[66:0] vector_in[0 : vindx - 1];

    zero_sign_ext dut(.data(data), .sel(sel), .trimm(trimm));

    initial begin
        $readmemh("input_zero_sign_ext.txt", vector_in);
        $dumpfile("waveform_zero_sign_ext.vcd");
        $dumpvars(0, tb_zero_sign_ext);
        for (integer i=0; i < vindx; i++)
        begin
            {sel, data, trimm_exp} = vector_in[i]; #10;
            assert 
                (trimm === trimm_exp) 
            else 
                $error("Failed at line %d : data=%h sel=%b trimm=%h", (i+1), data, sel, trimm);
        end
    end
endmodule
