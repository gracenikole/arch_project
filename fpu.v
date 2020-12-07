// vim: set expandtab:
`timescale 1ns/1ns

module fpu(a, b, double, Result);
    input [63:0] a, b;
    input double;

    output [63:0] Result;

    wire [31:0] f_result;
    wire [63:0] d_result;

    fp_adder float_a(
        .srcA(a[31:0]),
        .srcB(b[31:0]),
        .result(f_result)
    );

    double_adder double_a(
        .srcA(a),
        .srcB(b),
        .result(d_result)
    );

    assign Result = double ? d_result : {32'h0000, f_result} ;

endmodule
