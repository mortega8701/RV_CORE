module tb_prefix_adder();
    localparam N=5;
    logic[2**N-1:0] a, b, s, s_exp;
    logic cin, cout, cout_exp;
    prefix_adder #(N) dut(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));
    initial begin
		$dumpfile("waveform_prefix_adder.vcd");
		$dumpvars(0, tb_prefix_adder);
    end

    always begin
        for (integer i=0; i<=50; i++) begin
            a=$random;
            b=$random;
            cin=$random%32;
            {cout_exp, s_exp} = a + b + cin; #10;
            if(s!==s_exp || cout!==cout_exp) begin
                $display("Failed test at %d: a=%h, b=%h, cin=%b, s=%h",(i+1), a, b, cin, s);
            end
        end
        $stop;
    end
endmodule
