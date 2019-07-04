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
    if (exmemregwrite == 0 && exmemregwrite == 0) begin
        forwarda <= 2'b00;
        forwardb <= 2'b00;
    end
    if(exmemregwrite && ex_mem_rd!=0 && ex_mem_rd==rs) begin
        forwarda <= 2'b10;
        forwardb <= 2'b00;
    end
    else if(exmemregwrite && ex_mem_rd!=0 && ex_mem_rd==rt && regdst == 0) begin
        forwarda <= 2'b00;
        forwardb <= 2'b10;
    end
    else if(memwbregwrite && mem_wb_rd!=0 && mem_wb_rd==rs)begin
        forwarda <= 2'b01;
        forwardb <= 2'b00;
    end
    else if(memwbregwrite && mem_wb_rd!=0 && mem_wb_rd==rt && regdst == 0) begin
        forwarda <= 2'b01;
        forwardb <= 2'b00;
    end 
    else 
        begin
            forwarda <= 2'b00;
            forwardb <= 2'b00;
        end
    end
endmodule
