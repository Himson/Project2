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
    input flush,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] rd,
    input Regdst,
    input MemRead,
    input MemtoReg,
    input[1:0] ALUOp,
    input MemWrite,
    input ALUsrc,
    input RegWrite,
    input [31:0] Immediate,
    input [31:0] read1,
    input [31:0] read2,
    output reg [4:0] rsout = 5'b0,
    output reg [4:0] rtout = 5'b0,
    output reg [4:0] rdout = 5'b0,
    output reg Regdstout = 0,
    output reg MemReadout = 0,
    output reg MemtoRegout = 0,
    output reg[1:0] ALUOpout = 2'b0,
    output reg MemWriteout = 0,
    output reg ALUsrcout = 0,
    output reg RegWriteout = 0,
    output reg [31:0] Immediateout = 32'b0,
    output reg [31:0] read1out = 32'b0,
    output reg [31:0] read2out = 32'b0
    );
    always@(posedge clk)begin
    if(flush)begin   
        Regdstout <= 0;
        MemReadout <= 0;
        MemtoRegout <= 0;
        ALUOpout <= 0;
        MemWriteout <= 0;
        ALUsrcout <= 0;
        RegWriteout <= 0;
        Immediateout <= 0;
    end
    else begin
        rsout <= rs;
        rtout <= rt;
        rdout <= rd;
        read1out <= read1;
        read2out <= read2;
        Regdstout <= Regdst;
        MemReadout <= MemRead;
        MemtoRegout <= MemtoReg;
        ALUOpout <= ALUOp;
        MemWriteout <= MemWrite;
        ALUsrcout <= ALUsrc;
        RegWriteout <= RegWrite;
        Immediateout <= Immediate;
    end
    end
endmodule
