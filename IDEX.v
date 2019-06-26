`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 03:41:15 PM
// Design Name: 
// Module Name: IDEX
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


module IDEX(
    input clk,
    output reg Regdst,
    output reg Jump,
    output reg beq,
    output reg bne,
    output reg MemRead,
    output reg MemtoReg,
    output reg[1:0] ALUOp,
    output reg MemWrite,
    output reg ALUsrc,
    output reg RegWrite
    );
endmodule
