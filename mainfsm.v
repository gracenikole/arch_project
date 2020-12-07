// vim: set expandtab:

module mainfsm (
    clk,
    reset,
    Op,
    Funct,
    IRWrite,
    AdrSrc,
    ALUSrcA,
    ALUSrcB,
    ResultSrc,
    NextPC,
    RegW,
    MemW,
    Branch,
    ALUOp,
    long,
    lmulFlag,
    FpuW
);
    input wire clk;
    input wire reset;
    input wire [1:0] Op;
    input wire [5:0] Funct;
    output wire IRWrite;
    output wire AdrSrc;
    output wire [1:0] ALUSrcA;
    output wire [1:0] ALUSrcB;
    output wire [1:0] ResultSrc;
    output wire NextPC;
    output wire RegW;
    output wire MemW;
    output wire Branch;
    output wire ALUOp;
    output wire lmulFlag;
    output wire FpuW;
    reg [3:0] state;
    reg [3:0] nextstate;
    reg [14:0] controls;
    input wire long;

    localparam [3:0] FETCH    = 0;
    localparam [3:0] DECODE   = 1;
    localparam [3:0] MEMADR   = 2;
    localparam [3:0] MEMRD    = 3;
    localparam [3:0] MEMWB    = 4;
    localparam [3:0] MEMWR    = 5;
    localparam [3:0] EXECUTER = 6;
    localparam [3:0] EXECUTEI = 7;
    localparam [3:0] ALUWB    = 8;
    localparam [3:0] BRANCH   = 9;
    localparam [3:0] UNKNOWN  = 10;
    localparam [3:0] EXECUTEF = 11; // Float
    localparam [3:0] FPUWB    = 12; // FPU write back
    localparam [3:0] ALUWB2   = 13; // Long mult
    // state register
    always @(posedge clk or posedge reset)
        if (reset)
            state <= FETCH;
        else
            state <= nextstate;


    // ADD CODE BELOW
      // Finish entering the next state logic below.  We've completed the
      // first two states, FETCH and DECODE, for you.

      // next state logic
    always @(*)
        casex (state)
            FETCH: nextstate = DECODE;
            DECODE:
                case (Op)
                    2'b00:
                        if (Funct[5])
                            nextstate = EXECUTEI;
                        else
                            nextstate = EXECUTER;
                    2'b01: nextstate = MEMADR;
                    2'b10: nextstate = BRANCH;
                    2'b11: nextstate = EXECUTEF;
                    default: nextstate = UNKNOWN;
                endcase
            MEMADR:
                if(Funct[0])
                    nextstate = MEMRD;
                else
                    nextstate = MEMWR;
            MEMRD:    nextstate = MEMWB;
            MEMWB:    nextstate = FETCH;
            MEMWR:    nextstate = FETCH;
            EXECUTER: nextstate = long == 1 ? ALUWB2 : ALUWB;
            EXECUTEI: nextstate = long == 1 ? ALUWB2 : ALUWB;
            EXECUTEF: nextstate = FPUWB;
            FPUWB:    nextstate = FETCH;
            ALUWB:    nextstate = FETCH;
            ALUWB2:   nextstate = FETCH;
            BRANCH:   nextstate = FETCH;
            default:  nextstate = FETCH;
        endcase

    // ADD CODE BELOW
    // Finish entering the output logic below.  We've entered the
    // output logic for the first two states, FETCH and DECODE, for you.

    // state-dependent output logic
    always @(*)
        case (state)
            FETCH:    controls = 15'b1_0_0_0_1_0_10_01_10_0_0_0;
            DECODE:   controls = 15'b0_0_0_0_0_0_10_01_10_0_0_0;
            EXECUTER: controls = 15'b0_0_0_0_0_0_00_00_00_1_0_0;
            EXECUTEI: controls = 15'b0_0_0_0_0_0_00_00_01_1_0_0;
            ALUWB:    controls = 15'b0_0_0_1_0_0_00_00_00_0_0_0;
            MEMADR:   controls = 15'b0_0_0_0_0_0_00_00_01_0_0_0;
            MEMWR:    controls = 15'b0_0_1_0_0_1_00_00_00_0_0_0;
            MEMRD:    controls = 15'b0_0_0_0_0_1_00_00_00_0_0_0;
            MEMWB:    controls = 15'b0_0_0_1_0_0_01_00_00_0_0_0;
            BRANCH:   controls = 15'b0_1_0_0_0_0_10_00_01_0_0_0;
            EXECUTEF: controls = 15'b0_0_0_0_0_0_00_00_00_0_0_0;
            FPUWB:    controls = 15'b0_0_0_0_0_0_00_00_00_0_0_1;
            ALUWB2:   controls = 15'b0_0_0_1_0_0_00_00_00_0_1_0;
            default:  controls = 15'bxxxxxxxxxxxxxxx;
        endcase
    assign {NextPC, Branch, MemW, RegW, IRWrite, AdrSrc, ResultSrc, ALUSrcA, ALUSrcB, ALUOp, lmulFlag, FpuW} = controls;
endmodule

