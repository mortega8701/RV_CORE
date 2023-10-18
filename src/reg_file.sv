module reg_file (
    input logic clk,
    input logic we3,
    input logic[4:0] a1, a2, a3,
    input logic[31:0] wd3,
    output logic[31:0] rd1, rd2
);

    logic[31:0][31:0] rf;

    always_ff @(posedge clk) begin
        if (we3 == 1'b1) begin
            rf[a3] <= wd3;
        end
    end

    assign rd1 = (a1 != 5'b0) ? rf[a1] : 32'b0;
    assign rd2 = (a2 != 5'b0) ? rf[a2] : 32'b0;
endmodule
