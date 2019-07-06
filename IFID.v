`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 03:51:05 PM
// Design Name: 
// Module Name: IFID
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


module IFID(
    input clk,
    input [31:0] instruction,
    input [31:0] instru_addr_plus4,
    input ifflush,
    output reg[31:0] instru_out = 0,
    output reg[31:0] instru_addr_plus4_out = 0
    );
    always@(posedge clk, ifflush)begin
        if(ifflush == 1)begin
            instru_out <= 0;
            instru_addr_plus4_out <= 0;
        end
        else begin
            instru_out <= instruction;
            instru_addr_plus4_out <= instru_addr_plus4;
        end
    end
endmodule
