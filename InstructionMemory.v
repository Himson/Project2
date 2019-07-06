`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2019 06:39:10 PM
// Design Name: 
// Module Name: InstructionMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionMemory(
    input [31:0] addr,
    output reg [31:0] instru
    );
    parameter x = 32;
    integer i;

    reg [31:0] memory [0:x-1];

    initial begin
        for (i = 0; i < x; i = i + 1)
            memory[i] = 32'b0;
        `include "memory.txt"
    end

    always @(*)begin
        if(addr <= 7'b1111100)instru = memory[addr >> 2];
    end
endmodule
