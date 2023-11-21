module tb_data_mem();
    integer vindx;
    localparam max_test = 23;
    logic clk;
    logic we;
    logic[1:0] st;
    logic[2:0] lt;
    logic[31:0] a;
    logic[31:0] wd;
    logic[31:0] rd, rd_exp;
    logic[95:0] vector_in1[0 : max_test];
    logic[5:0] vector_in2[0 : max_test];

    data_mem dut(.a(a), .we(we), .lt(lt), .st(st), .wd(wd), .clk(clk), .rd(rd));

    initial begin
        $readmemh("input_data_mem1.txt", vector_in1);
        $readmemb("input_data_mem2.txt", vector_in2);
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
        {a, wd, rd_exp} <= vector_in1[vindx];
        {we, st, lt} <= vector_in2[vindx];
    end

    always @(negedge clk) begin
        if (rd !== rd_exp) begin
            $display("Failed at line %d : a=%h, rd=%h, wd=%h, we=%b, st=%b, lt=%b", (vindx+1), a, rd, wd, we, st, lt);
        end
        vindx <= vindx + 1;
        if (vindx > max_test) begin
            $display("Test finished");
            $finish;
        end
    end
endmodule
