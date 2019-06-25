`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 01:19:47 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input   [31:0]  Rs,
    input   [31:0]  Rt,
    input   [3:0]   ALUControl,
    output          zero,             
    output  reg[31:0]   result
    );
    assign zero = (result == 0);
    always@(Rs,Rt,ALUControl)begin 
    case(ALUControl)
        4'b0010: result = Rs+Rt;
        4'b0110: result=Rs-Rt;
        4'b0000: result=Rs&Rt;
        4'b0001: result=Rs|Rt;
        4'b0111: begin
        if(Rs<Rt) result = 32'h1;
        else result = 32'h0;
        end
        default: ;
    endcase
    end

    
endmodule
