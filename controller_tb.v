// vim: set expandtab:

module controller_tb;
    reg clk;
    reg reset;
    reg [31:0] Instr;
    reg [3:0] ALUFlags;

    wire PCWrite;
    wire MemWrite;
    wire RegWrite;
    wire IRWrite;
    wire AdrSrc;
    wire [1:0] RegSrc;
    wire [1:0] ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [1:0] ResultSrc;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;

    reg [31:0] i;
    reg [31:0] RAM [63:0];
    initial begin
        $readmemh("memfile.dat", RAM);
        i = 0;
    end

    controller c(
        .clk(clk),
        .reset(reset),
        .Instr(Instr[31:12]),
        .ALUFlags(ALUFlags),
        .PCWrite(PCWrite),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .IRWrite(IRWrite),
        .AdrSrc(AdrSrc),
        .RegSrc(RegSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );

    always begin
        clk <= 1;
        #(5);
        clk <= 0;
        #(5);
    end

    initial begin
        reset <= 1;
        ALUFlags = 0;
        #(10);

        reset <= 0;
        #(10);
    end

    always @(posedge clk) begin
        Instr = RAM[i][31:12];
        if(PCWrite) begin
            i += 1;
        end
    end

    initial begin
        $dumpfile("controller.vcd");
        $dumpvars;
    end
endmodule
