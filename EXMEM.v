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
    output reg [31:0] aluresultout,
    output reg [4:0] rdout,
    output reg MemReadout,
    output reg MemtoRegout,
    output reg MemWriteout,
    output reg RegWriteout,
    output reg [31:0] mem_forwarded_rtdata
    );
    initial #0 begin 
        aluresultout <= 32'b0;        
        rdout <= 5'b0;        
        MemReadout <= 0;        
        MemtoRegout <= 0;        
        MemWriteout <= 0;        
        RegWriteout <= 0;        
        mem_forwarded_rtdata <= 32'b0;
    end
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
