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
    initial #0 begin
        aluresultout <= 32'd0;
        memreadresultout <= 32'b0;
        rdout <= 5'b0;
        Regwriteout <= 1'b0;
        MemtoRegout <= 1'b0;
    end
    always@(posedge clk)begin
        aluresultout <= aluresult;
        memreadresultout <= memreadresult;
        rdout <= rd;
        Regwriteout <= Regwrite;
        MemtoRegout <= MemtoReg;
    end
endmodule
