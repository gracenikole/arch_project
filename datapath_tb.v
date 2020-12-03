`include "datapath.v"

module datapath_tb();

input wire clk;
    reg reset;
    wire [31:0] Adr;
    wire [31:0] WriteData;
    reg [31:0] ReadData;
    wire [31:0] Instr;
    wire [3:0] ALUFlags;
    reg PCWrite;
    reg RegWrite;
    reg IRWrite;
    reg AdrSrc;
    reg [1:0] RegSrc;
    reg [1:0] ALUSrcA;
    reg [1:0] ALUSrcB;
    reg [1:0] ResultSrc;
    reg [1:0] ImmSrc;
    reg [2:0] ALUControl;
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
    wire [31:0] ALUOut;
    wire [3:0] RA1;
    wire [3:0] RA2;

	datapath datapath(
		.clk(clk),
		.reset(reset),
		.Adr(Adr),
		.WriteData(WriteData),
		.ReadData(ReadData),
		.Instr(Instr[31:12]),
		.ALUFlags(ALUFlags),
		.PCWrite(PCWrite),
		.RegWrite(RegWrite),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.RegSrc(RegSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.ImmSrc(ImmSrc),
		.ALUControl(ALUControl),
		.PCNext(PCNext),
		.PC(PC),
		.ExtImm(ExtImm),
		.SrcA(SrcA),
		.SrcB(SrcB),
		.Result(Result),
		.Data(Data),
		.RD1(RD1),
		.RD2(RD2),
		.A(A),
		.ALUResult(ALUResult),
		.ALUOut(ALUOut),
		.RA1(RA1),
		.RA2(RA2)
	);

	initial begin
		$readmemh("dp.tv", RAM);
		i = 0;
	end

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
    end

	always @(posedge clk) begin
        Instr = RAM[i][31:0];
        $display("%d %h", i, Instr);

        if(^Instr === 1'bx) begin
            $finish;
        end

    end

	always @(negedge clk) begin
        if(PCWrite && !reset) begin
            i += 1;
        end
    end

    initial begin
        $dumpfile("datapath_tb_cs.vcd");
        $dumpvars;
    end
endmodule
