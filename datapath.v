// vim: set expandtab:

// ADD CODE BELOW
// Complete the datapath module below for Lab 11.
// You do not need to complete this module for Lab 10.
// The datapath unit is a structural SystemVerilog module. That is,
// it is composed of instances of its sub-modules. For example,
// the instruction register is instantiated as a 32-bit flopenr.
// The other submodules are likewise instantiated.
module datapath (
    clk,
    reset,
    Adr,
    WriteData,
    ReadData,
    Instr,
    ALUFlags,
    PCWrite,
    RegWrite,
    IRWrite,
    AdrSrc,
    RegSrc,
    ALUSrcA,
    ALUSrcB,
    ResultSrc,
    ImmSrc,
    ALUControl,
    lmulFlag,
    FpuWrite
);
    input wire clk;
    input wire reset;
    output wire [31:0] Adr;
    output wire [31:0] WriteData;
    input wire [31:0] ReadData;
    output wire [31:0] Instr;
    output wire [3:0] ALUFlags;
    input wire PCWrite;
    input wire RegWrite;
    input wire IRWrite;
    input wire AdrSrc;
    input wire [1:0] RegSrc;
    input wire [1:0] ALUSrcA;
    input wire [1:0] ALUSrcB;
    input wire [1:0] ResultSrc;
    input wire [1:0] ImmSrc;
    input wire [2:0] ALUControl;
    input wire lmulFlag;
    input wire FpuWrite;

    wire [31:0] PCNext;
    wire [31:0] PC;
    wire [31:0] ExtImm;
    wire [31:0] SrcA;
    wire [31:0] SrcB;
    wire [31:0] Result;
    wire [31:0] Data;
    wire [31:0] RD1;
    wire [31:0] RD2;
    wire [31:0] A;
    wire [31:0] ALUResult;
    wire [31:0] ALUResult2;
    wire [31:0] ALUOut;
    wire [31:0] ALUOut2;
    wire [3:0] RA1;
    wire [3:0] RA2;
    wire [63:0] FRD1;
    wire [63:0] FRD2;
    wire [63:0] FA;
    wire [63:0] FWriteData;
    wire [63:0] FResult;
    wire [63:0] FPUResult;


    // Your datapath hardware goes below. Instantiate each of the
    // submodules that you need. Remember that you can reuse hardware
    // from previous labs. Be sure to give your instantiated modules
    // applicable names such as pcreg (PC register), adrmux
    // (Address Mux), etc. so that your code is easier to understand.

    // ADD CODE HERE

    flopenr #(32) pcreg(
        .clk(clk),
        .reset(reset),
        .en(PCWrite),
        .d(PCNext),
        .q(PC)
    );

    mux2 #(32) adrmux(
        .d0(PC),
        .d1(PCNext),
        .s(AdrSrc),
        .y(Adr)
    );

    flopenr #(32) instrreg(
        .clk(clk),
        .reset(reset),
        .en(IRWrite),
        .d(ReadData),
        .q(Instr)
    );

    flopr #(32) datareg(
        .clk(clk),
        .reset(reset),
        .d(ReadData),
        .q(Data)
    );

    mux2 #(4) ra1mux(
        .d0(Instr[19:16]),
        .d1(4'd15),
        .s(RegSrc[0]),
        .y(RA1)
    );

    mux2 #(4) ra2mux(
        .d0(Instr[3:0]),
        .d1(Instr[15:12]),
        .s(RegSrc[1]),
        .y(RA2)
    );

    regfile rf(
        .clk(clk),
        .we3(RegWrite),
        .ra1(RA1),
        .ra2(RA2),
        .wa3(Instr[15:12]),
        .wa4(Instr[11:8]),
        .wd3(Result),
        .wd4(ALUOut2),
        .long(lmulFlag),
        .r15(Result),
        .rd1(RD1),
        .rd2(RD2)
    );

    extend ext(
        .Instr(Instr[23:0]),
        .ImmSrc(ImmSrc),
        .ExtImm(ExtImm)
    );

    flopr #(64) rdreg(
        .clk(clk),
        .reset(reset),
        .d({RD1, RD2}),
        .q({A, WriteData})
    );

    mux2 #(32) srcamux(
        .d0(A),
        .d1(PC),
        .s(ALUSrcA[0]),
        .y(SrcA)
    );

    mux3 #(32) srcbmux(
        .d0(WriteData),
        .d1(ExtImm),
        .d2(32'd4),
        .s(ALUSrcB),
        .y(SrcB)
    );

    alu a(
        .a(SrcA),
        .b(SrcB),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .Result2(ALUResult2),
        .ALUFlags(ALUFlags)
    );

    fpu_regfile fpu_regfile(
        .clk(clk),
        .we3(FpuWrite),
        .ra1(Instr[19:16]),
        .ra2(Instr[3:0]),
        .wa3(Instr[15:12]),
        .A1(Instr[7]),
        .A2(Instr[5]),
        .A3(Instr[6]),
        .sod(Instr[8]),
        .wd3(FResult),
        .rd1(FRD1),
        .rd2(FRD2)
    );

    flopr #(128) frdreg(
        .clk(clk),
        .reset(reset),
        .d({FRD1, FRD2}),
        .q({FA, FWriteData})
    );

    fpu f(
        .a(FA),
        .b(FWriteData),
        .double(Instr[8]),
        .Result(FPUResult)
    );

    flopr #(64) fpureg(
        .clk(clk),
        .reset(reset),
        .d(FPUResult),
        .q(FResult)
    );

    flopr #(32) alureg(
        .clk(clk),
        .reset(reset),
        .d(ALUResult),
        .q(ALUOut)
    );

    flopr #(32) alureg2(
        .clk(clk),
        .reset(reset),
        .d(ALUResult2),
        .q(ALUOut2)
    );

    mux3 #(32) resultmux(
        .d0(ALUOut),
        .d1(Data),
        .d2(ALUResult),
        .s(ResultSrc),
        .y(Result)
    );

    assign PCNext = Result;

endmodule
