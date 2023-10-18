module funnel_shifter #(parameter N=5) (
    input logic[2**N-1:0] upper,
    input logic[2**N-1:0] downer,
    input logic[N-1:0] shamt,
    input logic direction,
    output logic[2**N-1:0] shift
);

    logic[2**(N+1)-1:0] funnel;
    logic[N:0] up, down;

    assign funnel = {upper, downer};
    assign up = (direction == 1'b0) ? (2**N-1)+shamt : (2**(N+1)-1)-shamt;
    assign down = (direction == 1'b0) ? shamt : (2**N-1)-shamt;
    assign shift = funnel[up : down];
endmodule
