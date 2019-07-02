`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2019 10:31:26 PM
// Design Name: 
// Module Name: pipeline
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


module pipeline(
    input clk
    );
    wire [31:0] next4;
    wire [31:0] branchorjump;
    wire pcoption;
    wire [31:0] nextinstru;
    mux2to1 pcincomemux(
      next4,
      branchorjump,
      pcoption,
      nextinstru,        
    );
    wire stall;
    wire [31:0] instru_addr;
    ProgramCounter pc(
        clk,
        nextinstru,
        stall,
        instru_addr
    );
    wire [31:0] instru;
    InstructionMemory im(
        instru_addr,
        instru
    );
    wire [31:0] instru_addr_plus4;
    assign instru_addr_plus4 = instru_addr+4;
    wire ifflush;
    wire [31:0] instru_out;
    wire [31:0] instru_addr_plus4out;
    IFID ifid(
        clk,
        instru,
        instru_addr_plus4,
        ifflush,
        instru_out,
        instru_addr_plus4out 
    );
    wire [31:0] signexten;
    assign signexten = {{16{instru_out[15]}}, instru_out[15:0]};
    wire [31:0] branchaddress; // branch address
    assign branchaddress = instru_addr_plus4out + (signexten<<2) ;
    wire [4:0] idrs;
    wire [4:0] idrt;
    wire [4:0] idrd;
    assign idrs = instru_out[25:21];
    assign idrt = instru_out[20:16];
    assign idrd = instru_out[15:11];
    wire Regdst;
    wire Jump;
    wire beq;
    wire bne;
    wire MemRead;
    wire MemtoReg;
    wire[1:0] ALUOp;
    wire MemWrite;
    wire ALUsrc;
    wire RegWrite;
    control Control();   
    
endmodule
