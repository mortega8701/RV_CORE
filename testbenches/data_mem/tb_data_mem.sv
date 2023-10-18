module tb_data_mem();
	integer vindx;
	logic[31:0] address;
    logic write_enab;
    logic[31:0] write;
	logic[31:0] read, read_exp;
    logic clk;
	logic[96:0] vector_in[0 : 10];

	data_mem dut(.a(address), .we(write_enab), .wd(write), .clk(clk), .rd(read));

	initial begin
		$readmemh("input_data_mem.txt", vector_in);
		$dumpfile("waveform_data_mem.vcd");
		$dumpvars(0, tb_data_mem);
        vindx = 0;
    end

    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

    always @(posedge clk) begin
		{write_enab, address, write, read_exp} = vector_in[vindx];
	end

    always @(negedge clk) begin
        if (read !== read_exp) begin
            $display("Failed at line %d : address=%h read=%h", (vindx+1), address, read);
        end
        vindx++;
        if (vector_in[vindx] === 97'bx) begin
            $display("Test finished");
            $stop;
        end
	end
endmodule
