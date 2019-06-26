`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2019 06:39:10 PM
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input addr,
    input MemWrite,
    input MemRead,
    input [31:0] WriteData,
    output reg[31:0] ReadData
    );
    parameter x = 32;
    integer i;
    wire [31:0] ind;
    assign ind = addr >> 2; 
    reg [31:0] memory [0:x-1];

    initial begin
        for (i = 0; i < x; i = i + 1)
            memory[i] = 32'b0;
    end

    always@(MemRead,MemWrite)begin
        if(MemRead==1'b1)begin
            ReadData = memory[ind];
        end
        if(MemWrite==1'b1)begin
            memory[ind] = WriteData;
        end
    end
endmodule
