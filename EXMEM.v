`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 03:51:05 PM
// Design Name: 
// Module Name: EXMEM
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


module EXMEM(
    input clk,
    input flush,
    input Regdst,
    input Jump,
    input beq,
    input bne,
    input MemRead,
    input MemtoReg,
    input[1:0] ALUOp,
    input MemWrite,
    input ALUsrc,
    input RegWrite,
    output reg Regdstout,
    output reg Jumpout,
    output reg beqout,
    output reg bneout,
    output reg MemReadout,
    output reg MemtoRegout,
    output reg[1:0] ALUOpout,
    output reg MemWriteout,
    output reg ALUsrcout,
    output reg RegWriteout 
    );
endmodule
