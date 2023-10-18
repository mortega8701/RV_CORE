//Memory address can point to (2**32)/4 diferent instrctions
//This is a lot of memory so is needed to limit with a parameter
//we select how many bits of real address we can afford to reduce
//RAM memory (Default 12 bits = 4096 bytes = 1024 word address)

module data_mem #(parameter N=12)(
    input logic clk,
    input logic we,
    input logic[31:0] a,
    input logic[31:0] wd,
    output logic[31:0] rd 
);

    logic[31:0] RAM[0:2**N-1];

    initial begin
        $readmemh("LOAD_DATA.txt", RAM);
    end

    always_ff @(posedge clk) begin
        if (we == 1'b0)
            RAM[a[N-1:0]] <= wd;
    end

    assign rd = RAM[a[N-1:0]];
endmodule
