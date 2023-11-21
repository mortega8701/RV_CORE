//(Default 12 bits = 4096 bytes = 1024 word address)
module instr_mem #(parameter N=12)(
    input logic[31:0] a,
    output logic[31:0] rd
);

    logic[31:0] RAM[0:2**(N-2)-1];

    initial begin
        $readmemh("RV_INSTR.txt", RAM);
    end

    //4 Bytes alignment
    assign rd = RAM[a[N-1:2]];
endmodule
