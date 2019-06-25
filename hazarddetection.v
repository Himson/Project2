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
    input MemRead,
    input exrt,
    input idrs,
    input idrt,
    input exregwrite,
    input exreg
    output reg idflush = 0,
    output reg ifflush = 0,`
    output reg exflush = 0,
    output reg stall = 0
    );
    always@(*)begin
        if(MemRead && (idrs==exrt || idrt==exrt)) begin //load-store harzard detection
            stall = 1;
            idflush = 1;
        end
        else begin
            stall = 0;
            idflush = 0;
        if(beq==0) begin
            
        end

        end
    end
endmodule
