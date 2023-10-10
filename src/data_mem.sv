//Memory address can point to (2**32)/4 diferent instrctions
//This is a lot of memory so is needed to limit with a parameter
//however you must halt the program to avoid to overflow the memory

module data_mem #(parameter N=100)(
    input logic clk,
    input logic we,
    input logic[31:0] a,
    input logic[31:0] wd,
    output logic[31:0] rd 
);

    logic[N-1:0][31:0] RAM;

    always_ff @(posedge clk) begin
        if (we == 1'b0)
            RAM[a] <= wd;
    end

    assign rd = RAM[a];
endmodule
