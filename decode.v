// vim: set expandtab:

module decode (
    clk,
    reset,
    Op,
    Mop,
    Funct,
    Rd,
    FlagW,
    PCS,
    NextPC,
    RegW,
    MemW,
    IRWrite,
    AdrSrc,
    ResultSrc,
    ALUSrcA,
    ALUSrcB,
    ImmSrc,
    RegSrc,
    ALUControl
);
    input wire clk;
    input wire reset;
    input wire [1:0] Op;
    input wire [5:0] Funct;
    input wire [3:0] Mop;
    input wire [3:0] Rd;
    output reg [1:0] FlagW;
    output wire PCS;
    output wire NextPC;
    output wire RegW;
    output wire MemW;
    output wire IRWrite;
    output wire AdrSrc;
    output wire [1:0] ResultSrc;
    output wire [1:0] ALUSrcA;
    output wire [1:0] ALUSrcB;
    output wire [1:0] ImmSrc;
    output wire [1:0] RegSrc;
    output reg [2:0] ALUControl;
    wire Branch;
    wire ALUOp;

    // Main FSM
    mainfsm fsm(
        .clk(clk),
        .reset(reset),
        .Op(Op),
        .Funct(Funct),
        .IRWrite(IRWrite),
        .AdrSrc(AdrSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .NextPC(NextPC),
        .RegW(RegW),
        .MemW(MemW),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // ADD CODE BELOW
    // Add code for the ALU Decoder and PC Logic.
    // Remember, you may reuse code from previous labs.
    // ALU Decoder

    always @(*) begin
        if (ALUOp) begin
            if(Mop[3:0] == 4'b1001) begin
                case(Funct[4:1])
                    4'b0000: ALUControl = 3'b101; //MUL
                    4'b0100: ALUControl = 3'b110; //UMULL
                    4'b0110: ALUControl = 3'b111; //SMULL
                endcase
            end
            else begin
                case (Funct[4:1])
                    4'b0100: ALUControl = 3'b000; // ADD
                    4'b0010: ALUControl = 3'b001; // SUB
                    4'b0000: ALUControl = 3'b010; // AND
                    4'b1100: ALUControl = 3'b011; // ORR

                    4'b0001: ALUControl = 3'b100; // EOR

                    default: ALUControl = 3'bxx;

                endcase
            end
            FlagW[1] = Funct[0];
            FlagW[0] = Funct[0] & ((ALUControl == 3'b000) | (ALUControl == 3'b001));
        end
        else begin
            ALUControl = 3'b000;
            FlagW = 2'b00;
        end
    end

    // PC Logic

    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;

    // Add code for the Instruction Decoder (Instr Decoder) below.
    // Recall that the input to Instr Decoder is Op, and the outputs are
    // ImmSrc and RegSrc. We've completed the ImmSrc logic for you.

    // Instr Decoder
    assign ImmSrc = Op;
    assign RegSrc[0] = (Op == 2'b10);
    assign RegSrc[1] = (Op == 2'b01);

endmodule

