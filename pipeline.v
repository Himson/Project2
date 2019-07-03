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
    wire [31:0] if_current_instru_addr_plus4;
    wire [31:0] ifbranchorjump;
    wire if_pcmux_control;
    wire [31:0] nextinstru_addr;
    mux2to1 pcincomemux(
      if_current_instru_addr_plus4,
      ifbranchorjump,
      if_pcmux_control,
      nextinstru_addr,        `
    );
    wire harzard_detection2pc_stall;
    wire [31:0] current_instru_addr;
    ProgramCounter pc(
        clk,
        nextinstru_addr,
        harzard_detection2pc_stall,
        current_instru_addr
    );
    wire [31:0] if_current_instru;
    InstructionMemory im(
        current_instru_addr,
        if_current_instru
    );
    assign if_current_instru_addr_plus4 = instru_addr+4;
    wire ifflush;
    wire [31:0] id_instru;
    wire [31:0] id_instru_addr_plus4;
    IFID ifid(
        clk,
        if_current_instru,
        if_current_instru_addr_plus4,
        ifflush,
        id_instru,
        id_instru_addr_plus4 
    );
    wire [31:0] signexten;
    assign signexten = {{16{id_instru[15]}}, id_instru[15:0]};
    wire [31:0] branchaddress; // branch address
    assign branchaddress = id_instru_addr_plus4 + (signexten<<2) ;
    wire [4:0] idrs;
    wire [4:0] idrt;
    wire [4:0] idrd;
    assign idrs = id_instru[25:21];
    assign idrt = id_instru[20:16];
    assign idrd = id_instru[15:11];
    wire idRegdst;
    wire idJump;
    wire idbeq;
    wire idbne;
    wire idMemRead;
    wire idMemtoReg;
    wire[1:0] idALUOp;
    wire idMemWrite;
    wire idALUsrc;
    wire idRegWrite;
    control Control(
        instru,
        idRegdst,
        idJump,
        idbeq,
        idbe,
        MemRead,
        idMemtoReg,
        idALUOp,
        idMemWrite,
        idALUsrc,
        idRegWrite
    );   
    wire [3:0] idALUControl;
    ALUcontrol alucontrol(
        idALUOp,
        id_instru[5:0],
        idALUControl
    );
    wire [4:0] wbrd;
    wire [31:0] wbdata;
    wire wbregwrite;
    wire [31:0] idrsdata;
    wire [31:0] idrtdata;
    registerfile RF(
        clk,
        idrs,
        idrt,
        wbrd,
        wbdata,
        wbregwrite,
        idrsdata,
        idrtdata
    );
    wire idequal;
    wire [31:0] memforwardrd;
    wire branch_hazard_rs_control;
    wire branch_hazard_rt_control;
    wire [31:0] to_compare_rt;
    wire [31:0] to_compare_rs;
    mux2to1 forward_branch_hazard_rt(
        idrtdata,
        memforwardrd,
        branch_hazard_rt_control,
        to_compare_rt
    );
    mux2to1 forward_branch_hazard_rs(
        idrsdata,
        memforwardrd,
        branch_hazard_rs_control,
        to_compare_rt
    );
    assign idequal = (to_compare_rt==to_compare_rs);
    wire branch_or_not = (idbeq&&idequal)||(idbe&&!idequal);
    wire [27:0] id_instru_jump_addr_shift2;
    assign id_instru_jump_addr_shift2 = id_instru[25:0] << 2;
    wire [31:0] jump_addr = {id_instru_addr_plus4[31:28], id_instru_jump_addr_shift2};   
    assign if_pcmux_control = jump||branch_or_not;
    mux2to1 id_jump_or_branch_mux(
        branchaddress,
        jump_addr,
        jump,
        ifbranchorjump
    );
    hazarddetection hd(
        idbeq,
        idbe,
        idrs,
        idrt,
        idRegdst,
        idMemWrite,
    );
endmodule
