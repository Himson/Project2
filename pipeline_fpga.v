`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2019 09:08:17 PM
// Design Name: 
// Module Name: pipeline_fpga
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


module pipeline_fpga(
    input   wire    clock,
    input   wire    clock_100MHz,
    input   wire            Disp_PC,
    input   wire    [4:0]   RegisterIndex,        
    output  wire    [3:0]   Anodes,
    output  wire    [6:0]   Cathodes
    );
endmodule
