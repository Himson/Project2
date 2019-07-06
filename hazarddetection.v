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
    input [4:0] idrs,
    input [4:0] idrt,
    input idalusrc,
    input exregwrite,
    input exMemRead,
    input [4:0] exrd,
    input memregwrite,
    input [4:0] memrd,
    input mem_MemtoReg,
    output reg idflush = 0,
    output reg stall = 0,
    output reg forward1 = 0,
    output reg forward2 = 0
    );
    always@(*)begin
        if(exMemRead && (idrs == exrd)||(idrt == exrd && idalusrc == 0)) begin //load-use harzard detection
            stall = 1;
            idflush = 1;
            forward1 = 1'b0; 
            forward2 = 1'b0;
        end
        else if(beq || bne) begin
            if(exregwrite &&  (idrs == exrd || idrt == exrd))begin
                stall = 1;
                idflush = 1;
                forward1 = 1'b0; 
                forward2 = 0;
            end
            else if(memregwrite && (idrs == memrd || idrt == memrd)) begin
                if(mem_MemtoReg) begin
                    stall = 1;
                    idflush = 1;
                    forward1 = 1'b0;
                    forward2 = 1'b0;                         
                end
                else begin
                    stall = 0;
                    idflush = 0;
                    if(idrs == memrd) begin
                        forward1 = 1'b1;
                        forward2 = 1'b0;
                    end
                    else begin
                        forward1 = 1'b0;
                        forward2 = 1'b1;
                    end

            end
        end
        else begin
            stall <= 1'b0;
            idflush <= 1'b0;
            forward1 <= 1'b0; 
            forward2 <= 1'b0;            
        end
    end
    end
endmodule
