`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2019 07:13:43 PM
// Design Name: 
// Module Name: registerfile
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


module registerfile(
    input clk,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] writeaddr,
    input [31:0] writedata,
    input regwrite,
    output reg[31:0] rsdata,
    output reg[31:0] rtdata
    );
    parameter x = 32;
    integer i;
    reg [31:0] register [0:x-1];    

    initial begin
        for (i = 0; i < x; i = i + 1)
            register[i] <= 32'b0;
        rsdata <= 32'b0;
        rtdata <= 32'b0;
    end

    always@(*)begin
        if(clk==1'b1)begin
            if(regwrite == 1'b1)begin
                register[writeaddr] <= writedata;
            end
        end
        else begin
            rsdata <= register[rs];
            rtdata <= register[rt];
        end
    end
endmodule
