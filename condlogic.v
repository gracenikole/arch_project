// vim: set expandtab:

// ADD CODE BELOW
// Add code for the condlogic and condcheck modules. Remember, you may
// reuse code from prior labs.
module condlogic (
    clk,
    reset,
    Cond,
    ALUFlags,
    FlagW,
    PCS,
    NextPC,
    RegW,
    MemW,
    PCWrite,
    RegWrite,
    MemWrite
);
    input wire clk;
    input wire reset;
    input wire [3:0] Cond;
    input wire [3:0] ALUFlags;
    input wire [1:0] FlagW;
    input wire PCS;
    input wire NextPC;
    input wire RegW;
    input wire MemW;
    output wire PCWrite;
    output wire RegWrite;
    output wire MemWrite;
    wire [1:0] FlagWrite;
    wire [3:0] Flags;
    wire CondEx;
    wire CondExFlop;

    // Delay writing flags until ALUWB state
    //flopr #(2) flagwritereg(
    //    clk,
    //    reset,
    //    FlagW & {2 {CondEx}}, // input
    //    FlagWrite // output
    //);

    // TODO ALU flags
    assign FlagWrite = FlagW & {2 {CondEx}};

    // ADD CODE HERE
    condcheck cc(
        .Cond(Cond),
        .Flags(Flags),
        .CondEx(CondEx)
    );

    flopr #(1) condExReg(
        .clk(clk),
        .reset(reset),
        .d(CondEx),
        .q(CondExFlop)
    );

    flopenr #(2) ALUF1Reg(
        .clk(clk),
        .reset(reset),
        .en(FlagWrite[1]),
        .d(ALUFlags[3:2]),
        .q(Flags[3:2])
    );

    flopenr #(2) ALUF2Reg(
        .clk(clk),
        .reset(reset),
        .en(FlagWrite[0]),
        .d(ALUFlags[1:0]),
        .q(Flags[1:0])
    );

    assign MemWrite = CondExFlop & MemW;
    assign RegWrite = CondExFlop & RegWrite;
    assign PCWrite = NextPC | (PCS & CondExFlop);

endmodule

