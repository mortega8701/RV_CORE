//(Default 12 bits = 4096 bytes = 1024 word address)
module data_mem #(parameter N=12)(
    input logic clk,
    input logic we,
    input logic[2:0] op_size,
    input logic[31:0] a,
    input logic[31:0] wd,
    output logic[31:0] rd 
);

    initial begin
        $readmemh("LOAD_DATA.txt", RAM);
    end

    logic[31:0] RAM[0:2**(N-2)-1];

    logic[31:0] word_read;
    logic[15:0] half_read;
    logic[7:0] byte_read;

    assign word_read = RAM[a[N-1:2]];

    assign half_read = (a[1] == 1'b1) ? RAM[a[N-1:2]][31:16] : 
                                        RAM[a[N-1:2]][15:0];

    assign byte_read = (a[1:0] == 2'b11) ? RAM[a[N-1:2]][31:24] :
                       (a[1:0] == 2'b10) ? RAM[a[N-1:2]][23:16] :
                       (a[1:0] == 2'b01) ? RAM[a[N-1:2]][15:8] :
                                           RAM[a[N-1:2]][7:0];

    always_ff @(posedge clk) begin
        if (we == 1'b1) begin
            case (op_size)
                //sw (4 Bytes alignment)
                3'b010 : begin
                    RAM[a[N-1:2]] <= wd[31:0];
                end
                //sh (2 Bytes alignment)
                3'b001 : begin
                    case (a[1])
                        1'b1 : RAM[a[N-1:2]][31:16] <= wd[15:0];
                        1'b0 : RAM[a[N-1:2]][15:0] <= wd[15:0];
                    endcase
                end
                //sb (Byte alignment)
                3'b000 : begin
                    case(a[1:0])
                        2'b11 : RAM[a[N-1:2]][31:24] <= wd[7:0];
                        2'b10 : RAM[a[N-1:2]][23:16] <= wd[7:0];
                        2'b01 : RAM[a[N-1:2]][15:8] <= wd[7:0];
                        2'b00 : RAM[a[N-1:2]][7:0] <= wd[7:0];
                    endcase
                end
                default : begin end
            endcase
        end
    end

    always_comb begin
        case(op_size)
            //lw (4 Bytes alignment)
            3'b010 : rd = word_read;
            //lh (2 Bytes alignment)
            3'b001 : rd = {{16{half_read[15]}}, half_read};
            //lb (Byte alignment)
            3'b000 : rd = {{24{byte_read[7]}}, byte_read};
            //lhu (2 Bytes alignment)
            3'b101 : rd = {{16'b0}, half_read};
            //lbu (Byte alignment)
            3'b100 : rd = {{24'b0}, byte_read};
            //Load Error
            default : rd = 32'bx;
        endcase
    end
endmodule
