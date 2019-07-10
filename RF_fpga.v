`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2019 09:41:33 PM
// Design Name: 
// Module Name: RF_fpga
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


module RF_fpga(
    input clk,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] writeaddr,
    input [31:0] writedata,
    input regwrite,
    input  [4:0] index,
    output [31:0] rsdata,
    output [31:0] rtdata, 
    output [31:0] number
    );
    parameter x = 32;
    integer i;
    reg [31:0] register [0:x-1];    

    initial begin
        for (i = 0; i < x; i = i + 1)
            register[i] <= 32'b0;
//        rsdata <= 32'b0;
//        rtdata <= 32'b0;
    end
    assign number = register[index];
    assign rsdata = register[rs];
    assign rtdata = register[rt];
    always@(negedge clk)begin
//        if(clk==1'b0)begin
            if(regwrite == 1'b1)begin
            register[writeaddr] = writedata;
//            end
            register[0] = 0;
            // for (i = 1; i < x; i = i + 1)
            //     register[i] = register[i];         
            // end
//        end
//        else begin
//            rsdata = register[rs];
//            rtdata = register[rt];
        end
    end
endmodule
