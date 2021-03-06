// vim: set expandtab:
`timescale 1ns/1ns

module alu(a, b, ALUControl, Result, Result2, ALUFlags);
    input [31:0] a, b;
    // input signed [31:0] sa, sb;
    input [2:0] ALUControl;
    // ALUControl  | Operación
    // 000         | ADD
    // 001         | SUB
    // 010         | AND
    // 011         | ORR
    // 100         | EOR
    // 101         | MUL
    // 110         | UMULL
    // 111         | SMULL

    output reg [31:0] Result; // low
    output reg [31:0] Result2; // high
    output [3:0] ALUFlags;

    wire N, Z, C, V;
    wire [32:0] sum;

    wire [31:0]_b;
    assign _b = (ALUControl[0]? ~b : b); // Sin _b, el resultado es diferente.
    assign sum = a + _b + ALUControl[0];

    // Usé esto en lugar del switch para que Result no sea un reg.
    always @(*)
        casex (ALUControl[2:0])  //case, casex, casez
            3'b00?: Result = sum;
            3'b010: Result = a & b;
            3'b011: Result = a | b;
            3'b100: Result = a ^ b;
            3'b101: Result = a * b;
            3'b110: {Result, Result2} = a * b;
            3'b111:
            case({a[31],b[31]})
                2'b00: {Result,Result2} = a*b;
                2'b01: {Result,Result2} =-((a)*-(b));
                2'b10: {Result,Result2} =-(-(a)*(b));
                2'b11: {Result,Result2} = -(a) * -(b);
            endcase
        endcase

    // assign Result = ALUControl[2]? a^b:
    //     ALUControl[1]? (ALUControl[0]? (a|b) : (a&b)) : sum;

    assign N = Result[31];
    assign Z = Result == 0;
    and(C, sum[32], ~ALUControl[1]);
    and(V, ~ALUControl[1], sum[31] ^ a[31], ~ALUControl[0] ^ a[31] ^ b[31]);

    assign ALUFlags = {N, Z, C, V};

endmodule
