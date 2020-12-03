module testbench();
reg clk;
reg reset;
wire [31:0] WriteData, Adr;
wire MemWrite;

// instantiate device to be tested
top toptop(clk, reset, WriteData, Adr, MemWrite);
// initialize test
initial
    begin
        reset <= 1; #22; reset <= 0;
    end
    // generate clock to sequence tests
    always
    begin
        clk <= 1; #5; clk <= 0; #5;
    end
    // check that 7 gets written to address 0x64
    // at end of program
    always @(negedge clk)
    begin
        $display("%h", toptop.top.PC);
        if(MemWrite) begin
            if(Adr === 128 & WriteData === 254) begin
            $display("Simulation succeeded");
            $finish;
            end else if (Adr !== 80) begin
                $display("Simulation failed");
                $finish;
            end
        end
        if (^toptop.Instr === 1'bx) begin
            $fatal(1, "Simulation failed");
            $stop;
        end
    end
endmodule