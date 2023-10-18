module tb_instr_mem();
	localparam vindx = 6;
	logic[31:0] address;
	logic[31:0] read, read_exp;
	logic[63:0] vector_in[0 : vindx - 1];
	instr_mem dut(.a(address), .rd(read));
	initial
	begin
		$readmemh("input_instr_mem.txt", vector_in);
		$dumpfile("waveform_instr_mem.vcd");
		$dumpvars(0, tb_instr_mem);
		for (integer i=0; i < vindx; i++)
		begin
			{address, read_exp} = vector_in[i]; #10;
			assert (read === read_exp) else $error("Failed at line %d : address %h read %h", (i+1), address, read);
		end
	end
endmodule
