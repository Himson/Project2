`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 10:44:15 PM
// Design Name: 
// Module Name: control
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


module control(
    input [31:0] instruction,
    output reg Regdst,
    output reg Jump,
    output reg beq,
    output reg bne,
    output reg MemRead,
    output reg MemtoReg,
    output reg[1:0] ALUOp,
    output reg MemWrite,
    output reg ALUsrc,
    output reg RegWrite
    );
    always@(*)begin
        case(instruction[31:26])
            6'h0: 
            begin
                Regdst=1;
                Jump = 0;
                beq = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b10;
                MemWrite = 0;
                ALUsrc = 0;
                RegWrite = 1;
                bne = 0;
            end
            6'h23: //lw
            begin
                Regdst = 0;
                Jump = 0;
                beq = 0;
                MemRead = 1;
                MemtoReg = 1;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUsrc = 1;
                RegWrite = 1;
                bne = 0;
            end
            6'h2b:
            begin //sw
                Regdst = 0;
                Jump = 0;
                beq = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b00;
                MemWrite = 1;
                ALUsrc = 1;
                RegWrite = 0;
                bne = 0;
            end
            6'h4: //beq
            begin 
                Regdst = 0;
                Jump = 0;
                beq = 1;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b01;
                MemWrite = 0;
                ALUsrc = 1;
                RegWrite = 0;
                bne = 0;
            end  
            6'h5: //bne
            begin 
                Regdst = 0;
                Jump = 0;
                beq = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b01;
                MemWrite = 0;
                ALUsrc = 1;
                RegWrite = 0;
                bne = 1;
            end
            6'h2: //J
            begin 
                Regdst = 0;
                Jump = 1;
                beq = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b01;
                MemWrite = 0;
                ALUsrc = 0;
                RegWrite = 0;
                bne = 0;
            end
            6'h8: //addi
            begin 
                Regdst = 0;
                Jump = 0;
                beq = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUsrc = 1;
                RegWrite = 1;
                bne = 0;
            end   
            6'hc: //andi
            begin 
                Regdst = 0;
                Jump = 0;
                beq = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b11;
                MemWrite = 0;
                ALUsrc = 1;
                RegWrite = 1;
                bne = 0;
            end                        
            default:;             
        endcase
    end
endmodule
