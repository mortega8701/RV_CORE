//(Default 12 bits = 4096 Bytes)
module data_mem #(parameter N=12)(
    input logic clk,
    input logic we,
    input logic[1:0] st,
    input logic[2:0] lt,
    input logic[31:0] a,
    input logic[31:0] wd,
    output logic[31:0] rd 
);

    logic[7:0] RAM[0:2**N-1];

    logic[N-1:0] wd_a; //real word address
    logic[N-1:0] hf_a; //real half address
    logic[N-1:0] b_a;  //real byte address

    assign wd_a = {a[N-1:2], 2'b0};
    assign hf_a = {a[N-1:1], 1'b0};
    assign b_a = a[N-1:0];

    initial begin
        $readmemh("LOAD_DATA.txt", RAM);
    end

    always_ff @(posedge clk) begin
        if (we == 1'b1) begin
            case (st)
                //sw (4 Bytes alignment)
                2'b10 : {RAM[wd_a+3], RAM[wd_a+2], RAM[wd_a+1], RAM[wd_a]} <= wd[31:0];
                //sh (2 Bytes alignment)
                2'b01 : {RAM[hf_a+1], RAM[hf_a]} <= wd[15:0];
                //sb (Byte alignment)
                2'b00 : RAM[b_a] <= wd[7:0];
                //Store Error
                default : RAM[wd_a] <= RAM[wd_a];
            endcase
        end
    end

    always_comb begin
        case(lt)
            //lw (4 Bytes alignment)
            3'b110 : rd = {RAM[wd_a+3], RAM[wd_a+2], RAM[wd_a+1], RAM[wd_a]};
            //lh (2 Bytes alignment)
            3'b101 : rd = {{16{RAM[hf_a+1][7]}}, RAM[hf_a+1], RAM[hf_a]};
            //lb (Byte alignment)
            3'b100 : rd = {{24{RAM[b_a][7]}}, RAM[b_a]};
            //lhu (2 Bytes alignment)
            3'b001 : rd = {{16'b0}, RAM[hf_a+1], RAM[hf_a]};
            //lbu (Byte alignment)
            3'b000 : rd = {{24'b0}, RAM[b_a]};
            //Load Error
            default : rd = 32'bx;
        endcase
    end
endmodule
