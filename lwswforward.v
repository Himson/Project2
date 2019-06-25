`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 04:19:59 PM
// Design Name: 
// Module Name: lwswforward
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


module lwswforward(
    input [4:0] lwrd,
    input [4:0] swrs,
    input memwrite,
    input mem2reg,
    output reg control
    );
    always@(*)begin
        if(mem2reg && memwrite && lwrd==swrs)
            control = 1;
        else control = 0;
    end
endmodule
