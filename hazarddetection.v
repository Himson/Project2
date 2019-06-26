`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 03:51:05 PM
// Design Name: 
// Module Name: hazarddetection
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


module hazarddetection(
    input beq,
    input bne,
    input equal,
    input idrs,
    input idrt,
    input idregdst,
    input idMemwrite,
    input exregwrite,
    input exMemRead,
    input exrt,
    input exrd,
    input exregdst,
    input memregwrite,
    input memrd,
    input MemtoReg,
    output reg idflush = 0,
    output reg stall = 0,
    output reg forward
    );
    always@(*)begin
        if(exMemRead && (idrs==exrt || idrt==exrt)) begin //load-store harzard detection
            stall = 1;
            idflush = 1;
            forward = 1'b0; 
        end
        else if(beq || bne) begin
            if(exregwrite && (((idrs == exrd || idrt == exrd)&& exregdst == 0) ||((idrs == exrt || idrt == exrt) && exregdst == 1)) )begin
                stall = 1;
                idflush = 1;
                forward = 1'b0; 
            end
            else if(memregwrite && (idrs == memrd || idrt == memrd)) begin
                if(MemtoReg) begin
                    stall = 1;
                    idflush = 1;
                    forward = 1'b0;                         
                end
                else forward = 1'b1;
            end
        end
    end
endmodule
