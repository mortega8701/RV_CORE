//(Default 16 bits = 65536 Bytes)
module data_mem #(parameter N=16)(
    input logic clk,
    input logic we,
    input logic[1:0] st,
    input logic[2:0] lt,
    input logic[31:0] a,
    input logic[31:0] wd,
    output logic[31:0] rd 
);

    logic[7:0] RAM[0:2**N-1];

    initial begin
        $readmemh("LOAD_DATA.txt", RAM);
    end

    //NO Byte alignment
    always_ff @(posedge clk) begin
        if (we == 1'b1) begin
            case (st)
                2'b10 : RAM[a] <= wd[31:0]; //sw
                2'b01 : RAM[a] <= wd[15:0]; //sh
                2'b00 : RAM[a] <= wd[7:0];  //sb
                default : RAM[a] <= RAM[a]; //Store Error
            endcase
        end
    end

    //NO Byte alignment
    assign rd = (lt == 3'b110) ? {RAM[a+3], RAM[a+2], RAM[a+1], RAM[a]} : //lw
                (lt == 3'b101) ? {{16{RAM[a+1][7]}}, RAM[a+1], RAM[a]} :  //lh
                (lt == 3'b100) ? {{24{RAM[a][7]}}, RAM[a]} :              //lb
                (lt == 3'b001) ? {{16'b0}, RAM[a+1], RAM[a]} :            //lhu
                (lt == 3'b000) ? {{24'b0}, RAM[a]} :                      //lbu
                32'bx;                                                    //Read Error
endmodule
