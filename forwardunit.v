`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 03:51:05 PM
// Design Name: 
// Module Name: forwardunit
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


module forwardunit(
    input [4:0] exrd,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] memrd,
    input exregwrite,
    input memregwrite,
    output reg[1:0] forwarda,
    output reg[1:0] forwardb
    );
    
    always@(*)begin
    if(exregwrite && exrd!=0 && exrd==rs) forwarda=2'b10;
    else if(exregwrite && exrd!=0 && exrd==rt) forwardb = 2'b10;
    else if(memregwrite && memrd!=0 && memrd==rs) forwarda=2'b01;
    else if(memregwrite && memrd!=0 && memrd==rt) forwarda=2'b01;
    end
endmodule
