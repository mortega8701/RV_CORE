module tb_prefix_adder();
    localparam vindx = 8;
    logic[31:0] a, b, s, s_exp;
    logic cin, cout, cout_exp;
    logic[97:0] vector_in[0 : vindx - 1];

    prefix_adder dut(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

    initial begin
        $readmemh("input_prefix_adder.txt", vector_in);
		$dumpfile("waveform_prefix_adder.vcd");
		$dumpvars(0, tb_prefix_adder);
		for (integer i=0; i < vindx; i++)
		begin
			{a, b, cin} = vector_in[i]; #10;
            {cout_exp, s_exp} = a + b + cin;
			assert 
                (cout === cout_exp && s === s_exp) 
            else 
                $error("Failed at line %d : a=%h b=%h cin=%b cout=%b sum=%h", (i+1), a, b, cin, cout, s);
		end
    end
endmodule
