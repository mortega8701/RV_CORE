module tb_reg_file();
    integer vindx;
    localparam max_test = 10;
    logic[4:0] a1, a2, a3;
    logic we3;
    logic[31:0] wd3;
    logic[31:0] rd1, rd2, rd1_exp, rd2_exp;
    logic clk;
    logic[95:0] vector_in1[0 : max_test];
    logic[15:0] vector_in2[0 : max_test];

    reg_file dut(.clk(clk), .we3(we3), .a1(a1), .a2(a2), .a3(a3), .rd1(rd1), .rd2(rd2), .wd3(wd3));

    initial begin
        $readmemh("input_reg_file1.txt", vector_in1);
        $readmemb("input_reg_file2.txt", vector_in2);
        $dumpfile("waveform_reg_file.vcd");
        $dumpvars(0, tb_reg_file);
        vindx = 0;
    end

    always begin
        clk <= 0; #10;
        clk <= 1; #10;
    end

    always @(posedge clk) begin
        #1;
        {rd1_exp, rd2_exp, wd3} <= vector_in1[vindx];
        {we3, a1, a2, a3} <= vector_in2[vindx];
    end

    always @(negedge clk) begin
        if (rd1 !== rd1_exp && rd2 !== rd2_exp) begin
            $display("Failed at line %d : we3=%b, a1=%h, a2=%h, a3=%h, rd1=%h, rd2=%h, wd3=%h", (vindx+1), we3, a1, a2, a3, rd1, rd2, wd3);
        end
        vindx <= vindx + 1;
        if (vindx > max_test) begin
            $display("Test finished");
            $finish;
        end
    end
endmodule
