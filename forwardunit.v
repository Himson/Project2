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
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] ex_mem_rd,
    input [4:0] mem_wb_rd,
    input regdst,
    input exmemregwrite,
    input memwbregwrite,
    input exmem_memread,
    output reg[1:0] forwarda,
    output reg[1:0] forwardb
    );
    always@(*)begin
        if(exmemregwrite && rs==ex_mem_rd && rs != 0)
            forwarda = 2'b10;
        else if(memwbregwrite && rs==mem_wb_rd && rs != 0)
            forwarda = 2'b01;
        else forwarda = 2'b00;

        if(exmemregwrite && rt==ex_mem_rd && rt != 0)
            forwardb = 2'b10;
        else if(memwbregwrite && rt==mem_wb_rd && rt != 0)
            forwardb = 2'b01;
        else forwardb = 2'b00;
    end
endmodule
