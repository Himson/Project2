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
    input [31:0] aluresult,
    input [4:0] rd,
    input MemRead,
    input MemtoReg,
    input[3:0] ALUControl,
    input MemWrite,
    input ALUsrc,
    input RegWrite,
    output reg [31:0] aluresultout,
    output reg [4:0] rdout,
    output reg Jumpout,
    output reg MemReadout,
    output reg MemtoRegout,
    output reg[1:0] ALUControlout,
    output reg MemWriteout,
    output reg RegWriteout 
    );
    always@(posedge clk)begin  
        aluresultout <= aluresult;
        rdout <= rd;
        MemReadout <= MemRead;
        MemtoRegout <= MemtoReg;
        ALUControlout <= ALUControl;
        RegWriteout <= RegWrite;    
    end
endmodule
