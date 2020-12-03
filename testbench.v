// vim: set expandtab:

module testbench;
    reg clk;
    reg reset;
    wire [31:0] WriteData;
    wire [31:0] Adr;
    wire MemWrite;
    wire _PC[31:0];

    top dut(
        .clk(clk),
        .reset(reset),
        .WriteData(WriteData),
        .Adr(Adr),
        .MemWrite(MemWrite)
    );

    initial begin
        reset <= 1;
        #(5)
            ;
        reset <= 0;
    end
    always begin
        clk <= 1;
        #(5)
            ;
        clk <= 0;
        #(5)
            ;
    end
    always @(negedge clk) begin
        $display("%h %h %h %h", dut.arm.dp.PC, Adr, dut.arm.dp.ReadData, dut.MemWrite);

        if (MemWrite)
            if ((Adr === 100) & (WriteData === 7)) begin
                $display("Simulation succeeded");
                $finish;
            end

       if (!reset & ^dut.arm.Instr === 1'bx) begin
            $fatal(1, "Simulation failed");
            $stop;
       end

    end
    initial begin
        $dumpfile("arm_multi.vcd");
        $dumpvars;
    end
endmodule
