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
    // reg [1:0] state;
    // initial #0 state <= 0;
    always@(*)begin
        // case(state)
        //     2'b00:begin
        //         if(exMemRead == 1 && ((idrs == exrd)||(idrt == exrd && idalusrc == 0))) state<=2'b01;
        //         else if(beq == 1||bne == 1) state <= 2'b10;
        //         else begin
        //             stall    <= 1'b0;
        //             idflush  <= 1'b0;
        //             forward1 <= 1'b0; 
        //             forward2 <= 1'b0;
        //         end    
        //     end  
        //     2'b01:

        // endcase
        if (!(beq == 1||bne == 1||exMemRead ==1))begin
            stall    <= 1'b0;
            idflush  <= 1'b0;
            forward1 <= 1'b0; 
            forward2 <= 1'b0;  
        end
        if(exMemRead == 1) begin //load-use harzard detection
            if((idrs == exrd)||(idrt == exrd && idalusrc == 0)) begin
                stall <= 1;
                idflush <= 1;
                forward1 <= 1'b0; 
                forward2 <= 1'b0;
            end
            else begin
                stall    <= 1'b0;
                idflush  <= 1'b0;
                forward1 <= 1'b0; 
                forward2 <= 1'b0; 
            end
        end
        if(beq == 1 || bne == 1) begin
            if(exregwrite == 0 && memregwrite == 0)begin
                stall    <= 1'b0;
                idflush  <= 1'b0;
                forward1 <= 1'b0; 
                forward2 <= 1'b0;                  
            end
            if(exregwrite == 1)begin
                if(idrs == exrd || idrt == exrd)begin
                    stall = 1;
                    idflush = 1;
                    forward1 = 0; 
                    forward2 = 0;
                end
            end
            else if(memregwrite == 1) begin
                if((idrs == memrd || idrt == memrd)) begin
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
                    stall    <= 1'b0;
                    idflush  <= 1'b0;
                    forward1 <= 1'b0; 
                    forward2 <= 1'b0;                  
                end
            end
        end
    end
endmodule
