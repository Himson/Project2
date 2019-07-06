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
    input MemWrite,
    input RegWrite,
    input [31:0] ex_forwarded_rtdata,
    output reg [31:0] aluresultout = 0,
    output reg [4:0] rdout = 0,
    output reg MemReadout = 0,
    output reg MemtoRegout = 0,
    output reg MemWriteout = 0,
    output reg RegWriteout = 0,
    output reg [31:0] mem_forwarded_rtdata = 0
    );
    always@(posedge clk)begin  
        aluresultout <= aluresult;
        rdout <= rd;
        MemReadout <= MemRead;
        MemtoRegout <= MemtoReg;
        MemWriteout <= MemWrite;
        RegWriteout <= RegWrite;  
        mem_forwarded_rtdata <= ex_forwarded_rtdata;
    end
endmodule
