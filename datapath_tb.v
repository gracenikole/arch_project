// clk, reset, PC, Instr, state, and ALUResult
module datapath_tb();
  reg clk;
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

datapath datapath(
  clk, reset, Adr, 
  WriteData, ReadData, 
  Instr, ALUFlags, PCWrite, 
  RegWrite, IRWrite, AdrSrc, 
  RegSrc, ALUSrcA, ALUSrcB, 
  ResultSrc, ImmSrc, ALUControl
);
// initialize test
initial
    begin
        reset <= 1; #10; reset <= 0;
    end
    // generate clock to sequence tests
    always
    begin
      clk <= 1; #5; clk <= 0; #5;
    end

    always @(negedge clk)
    begin
      // Podemos llegar al state a través del mainfsm, decode, controller, arm, top, datapath?tb
        $display("%h", clk);
        // if(MemWrite) begin
        //     if(Adr === 128 & WriteData === 254) begin
        //     $display("Simulation succeeded");
        //     $finish;
        //     end 
            // else if (Adr !== 80) begin
            //     $display("Simulation failed");
            //     $finish;
            // end
        // end
        if (^Instr === 1'bx) begin
            $fatal(1, "Simulation failed");
            $stop;
        end
    end
endmodule