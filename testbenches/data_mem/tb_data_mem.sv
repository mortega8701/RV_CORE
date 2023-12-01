module tb_data_mem();
    integer vindx;
    localparam max_test = 23;
    logic clk;
    logic we;
    logic[2:0] op_size;
    logic[31:0] a;
    logic[31:0] wd;
    logic[31:0] rd, rd_exp;
    logic[95:0] vector_words[0 : max_test];
    logic[3:0] vector_control[0 : max_test];

    data_mem dut(.a(a), .we(we), .op_size(op_size), .wd(wd), .clk(clk), .rd(rd));

    initial begin
        $readmemh("input_data_mem_words.txt", vector_words);
        $readmemb("input_data_mem_control.txt", vector_control);
        $dumpfile("waveform_data_mem.vcd");
        $dumpvars(0, tb_data_mem);
        vindx = 0;
    end

    always begin
        clk <= 0; #10;
        clk <= 1; #10;
    end

    always @(posedge clk) begin
        #1;
        {a, wd, rd_exp} <= vector_words[vindx];
        {we, op_size} <= vector_control[vindx];
    end

    always @(negedge clk) begin
        if (rd !== rd_exp) begin
            $display("Failed at line %d : a=%h, rd=%h, wd=%h, we=%b, op_size=%b", (vindx+1), a, rd, wd, we, op_size);
        end
        vindx = vindx + 1;
        if (vindx >= max_test) begin
            $display("Test finished");
            $finish;
        end
    end
endmodule
