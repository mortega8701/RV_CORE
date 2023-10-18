module funnel_shifter #(parameter N=5) (
    input logic[2**N-1:0] upper,
    input logic[2**N-1:0] downer,
    input logic[N-1:0] shamt,
    input logic direction,
    output logic[2**N-1:0] shift
);

    logic[2**(N+1)-1:0] funnel;
    assign funnel = {upper, downer};
    assign shift = (direction == 1'b0) ? 
        funnel[(2**N-1+shamt):(shamt)] : 
        funnel[(2**(N+1)-1-shamt):(2**N-1-shamt)];
endmodule
