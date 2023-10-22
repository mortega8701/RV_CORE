module zero_sign_ext (
    input logic[31:0] data,
    input logic[2:0] sel,
    output logic[31:0] trimm 
);
    assign trimm = (sel[2]) ? data[31:0] :
                   (sel[1:0] == 2'b00) ? {16'b0, data[15:0]} :
                   (sel[1:0] == 2'b01) ? {24'b0, data[7:0]} :
                   (sel[1:0] == 2'b10) ? {{16{data[15]}}, data[15:0]} :
                   (sel[1:0] == 2'b11) ? {{24{data[7]}}, data[7:0]} :
                   32'bx;
endmodule
