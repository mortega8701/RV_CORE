//Memory address can point to (2**32)/4 diferent instrctions
//This is a lot of memory so is needed to limit with a parameter
//however you must halt the program to avoid to overflow the memory

module instr_mem #(parameter N=100)(
    input logic[31:0] a,
    output logic[31:0] rd
);

    logic[N-1:0][31:0] RAM;
    initial begin
        $readmemh("RV_INSTR.txt", RAM);
    end

    assign rd = RAM[a];
endmodule
