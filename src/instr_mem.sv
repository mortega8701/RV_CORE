//Memory address can point to (2**32)/4 diferent instrctions
//This is a lot of memory so is needed to limit with a parameter
//we select how many bits of real address we can afford to reduce
//RAM memory (Default 12 bits = 4096 bytes = 1024 word address)

module instr_mem #(parameter N=12)(
    input logic[31:0] a,
    output logic[31:0] rd
);

    logic[31:0] RAM[0:2**N-1];

    initial begin
        $readmemh("RV_INSTR.txt", RAM);
    end

    //here we do some word alignment (4 Bytes)
    assign rd = RAM[a[N-1:2]];
endmodule
