module tb_data_mem();
    integer vindx;
    logic[31:0] a;
    logic we;
    logic[31:0] wd;
    logic[31:0] rd, rd_exp;
    logic clk;
    logic[96:0] vector_in[0 : 10];

    data_mem dut(.a(a), .we(we), .wd(wd), .clk(clk), .rd(rd));

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
		{we, a, wd, rd_exp} = vector_in[vindx];
	end

    always @(negedge clk) begin
        if (rd !== rd_exp) begin
            $display("Failed at line %d : a=%h, rd=%h, wd=%h, we=%b", (vindx+1), a, rd, wd, we);
        end
        vindx++;
        if (vector_in[vindx] === 97'bx) begin
            $display("Test finished");
            $stop;
        end
	end
endmodule
