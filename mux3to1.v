`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 03:51:05 PM
// Design Name: 
// Module Name: mux3to1
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


module mux3to1(
    input [31:0] port0,
    input [31:0] port1,
    input [31:0] port2,
    input [1:0] control,
    output reg[31:0] out
    );
    always@(*)begin
        case(control)
            2'b00: out = port0;
            2'b01: out = port1;
            2'b10: out = port2;
            default out = port0;
        endcase
    end
endmodule
