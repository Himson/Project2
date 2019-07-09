`timescale 1ns / 1ps

module single(
    
);
    reg clk = 1;
    wire [4:0] rs; 
    wire [4:0] rt;
    wire [4:0] rd;
    wire [31:0] writedata;
    wire [31:0] rsdata;
    wire [31:0] rtdata;
    registerfile RF(
        clk,
        rs,
        rt,
        rd,
        writedata,
        regwrite,
        rsdata,
        rtdata
    );





    integer i = 0;
    always #50 begin
        $display("Time: %d, CLK = %d, PC = 0x%H", i, clk, next_instruction_addr);
        $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", RF.register[16], RF.register[17], RF.register[18]);
        $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", RF.register[19], RF.register[20], RF.register[21]);
        $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", RF.register[22], RF.register[23], RF.register[8]);
        $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", RF.register[9], RF.register[10], RF.register[11]);
        $display("MEM[1] = 0x%H, MEM[8] = 0x%H",dm.memory[1],dm.memory[8]);
        $display("----------------------------------------------------------");
        clk = ~clk;
        if (clk) i = i + 1;
    end
endmodule