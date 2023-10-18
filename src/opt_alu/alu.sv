module alu
    (input logic[31:0] a,
    input logic[31:0] b,
    input logic[1:0] control,
    output logic[31:0] result,
    output logic[3:0] flags);
    
    logic N,Z,C,V;
    logic[31:0] sum;
    logic cout;

    always_comb begin
        {cout, sum} = a+((control[0]==1)?~b:b)+control[0];
        case (control)
            2'b00 : result = sum;
            2'b01 : result = sum;
            2'b10 : result = a & b;
            2'b11 : result = a | b;
            default : result = 32'bx;
        endcase
        N = result[31];
        Z = &(~result);
        C = ~control[1] & cout;
        V = ~(a[31] ^ b[31] ^ control[0]) & (a[31] ^ sum[31]) & ~control[1];
        flags = {N,Z,C,V};
    end
endmodule
