`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 03:51:05 PM
// Design Name: 
// Module Name: MEMWB
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


module MEMWB(
    input clk,
    input [31:0] aluresult,
    input [31:0] memreadresult,
    input [4:0] rd,
    input Regwrite,
    input MemtoReg,
    output reg [31:0] aluresultout,
    output reg [31:0] memreadresultout,
    output reg [4:0] rdout,
    output reg Regwriteout,
    output reg MemtoRegout
    );
    initial begin
        aluresultout <= 0;
        memreadresultout <= 0;
        rdout <= 0;
        Regwriteout <= 0;
        MemtoRegout <= 0;
    end
    always@(posedge clk)begin
        aluresultout <= aluresult;
        memreadresultout <= memreadresult;
        rdout <= rd;
        Regwriteout <= Regwrite;
        MemtoRegout <= MemtoReg;
    end
endmodule
