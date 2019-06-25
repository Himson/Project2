`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 02:37:31 PM
// Design Name: 
// Module Name: ALUcontrol
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


module ALUcontrol(
    input [1:0] ALUOp,
    input [5:0] funct, 
    output reg[3:0] ALUControl
    );
    
    always@(funct,ALUOp)begin
        case(ALUOp)
         2'b00: 
            ALUControl=4'b0010;
         2'b01: 
            ALUControl=4'b0110;
         2'b10: 
         begin
             case(funct)
                6'b100000: ALUControl=4'b0010;
                6'b100010: ALUControl=4'b0110;
                6'b100100: ALUControl=4'b0000;
                6'b100101: ALUControl=4'b0001;
                6'b101010: ALUControl=4'b0111;  
                default: ;
             endcase
         end
         default: ;
         endcase
    end
    
endmodule
