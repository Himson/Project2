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

    wire [4:0] wbrd;
    wire [31:0] wb_write_to_reg_data;
    wire wbregwrite;
    wire [31:0] idrsdata;
    wire [31:0] idrtdata;
    registerfile RF(
        clk,
        idrs,
        idrt,
        wbrd,
        wb_write_to_reg_data,
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
    wire [4:0] exrs;
    wire [4:0] exrt;
    wire [4:0] exrd;
    wire exRegdst;
    wire exMemRead;
    wire exMemtoReg;
    wire exALUOp;
    wire [3:0] exALUControl;
    wire exMemWrite;
    wire exALUsrc;
    wire exRegWrite;
    wire [31:0] exImmediate;
    wire [31:0] exrsdata;
    wire [31:0] exrtdata;
    ALUcontrol alucontrol(
        exALUOp,
        exImmediate[5:0],
        exALUControl
    );
    wire harzard_detection_id_flush;   
    IDEX idex(
        clk,
        harzard_detection_id_flush,
        idrs,
        idrt,
        idrd,
        idRegdst,
        idMemRead,
        idMemtoReg,
        idALUOp,
        idMemWrite,
        idALUsrc,
        idRegWrite,
        signexten,
        idrsdata,
        idrtdata,
        exrs,
        exrt,
        exrd,
        exRegdst,
        exMemRead,
        exMemtoReg,
        exALUOp,
        exMemWrite,
        exALUsrc,
        exRegWrite,
        exImmediate,
        exrsdata,
        exrtdata
    );
    wire aluzero;
    wire [31:0] ex_alu_result;
    wire [31:0] ex_forwarded_rsdata;
    wire [31:0] ex_forwarded_rtdata;
    wire [31:0] mem_alu_result;
    wire [31:0] wb_write_to_reg_data;
    wire [31:0] ex_forwarded_or_immediate_rtdata;
    wire forward_a_control;
    wire forward_b_control;
    mux3to1 rs_forward_a_mux(
        exrsdata,
        wb_write_to_reg_data,
        mem_alu_result,
        forward_a_control,
        ex_forwarded_rsdata
    );
    mux3to1 rt_forward_a_mux(
        exrtdata,
        wb_write_to_reg_data,
        mem_alu_result,
        forward_b_control,
        ex_forwarded_rtdata
    );
    mux2to1 rt_immediate_mux(
        ex_forwarded_rtdata,
        exImmediate,
        exALUsrc,
        ex_forwarded_or_immediate_rtdata
    );
    wire [4:0] ex_writeback_rd;
    mux2to1 Regdst_mux(
        exrt,
        exrd,
        exRegWrite,
        ex_writeback_rd
    )
    
    ALU alu(
        ex_forwarded_rsdata,
        ex_forwarded_or_immediate_rtdata,
        ALUcontrol,
        aluzero
        ex_alu_result
    );
    wire [31:0] mem_alu_result;
    wire [4:0] mem_rd;
    wire mem_MemRead;
    wire mem_MemtoReg;
    wire mem_MemWrite;
    wire mem_RegWrite;
    EXMEM exmem(
        clk,
        ex_alu_result,
        ex_writeback_rd,
        exMemRead,
        exMemtoReg,
        exMemWrite,
        exRegWrite,
        mem_alu_result,
        mem_rd,
        mem_MemRead,
        mem_MemtoReg,
        mem_MemWrite,
        mem_RegWrite
    );
    wire [31:0] mem_forwarded_rtdata;
    wire [31:0] mem_memory_readdata;
    DataMemory dm(
        mem_alu_result,
        mem_MemWrite,
        mem_MemRead,
        mem_forwarded_rtdata,
        mem_memory_readdata
    )
    wire [31:0] wb_alu_result;
    wire [31:0] wb_memory_readdata;
    wire [4:0] wb_rd;
    wire wbregwrite;
    wire wb_MemtoReg;
    MEMWB memwb(
        clk,
        mem_alu_result,
        mem_memory_readdata,
        mem_rd,
        mem_RegWrite,
        mem_MemtoReg,
        wb_alu_result,
        wb_memory_readdata,
        wb_rd,
        wbregwrite,
        wb_MemtoReg
    );
    mux2to1 Mem_or_alu_to_Reg_mux(
        wb_alu_result,
        wb_memory_readdata,
        wb_MemtoReg,
        wb_write_to_reg_data
    );
    hazarddetection hd(
        idbeq,
        idbe,
        idrs,
        idrt,
        idRegdst,
        idMemWrite,
        exRegWrite,
        exMemRead,
        exrt,
        exrd,
        mem_RegWrite,
        mem_rd,
        mem_MemtoReg,
        harzard_detection_id_flush,
        harzard_detection2pc_stall,
        branch_hazard_rs_control,
        branch_hazard_rt_control      
    );
    forwardunit forward(
        exrs,
        exrt,
        mem_rd,
        wb_rd,
        exRegdst,
        mem_RegWrite,
        wbregwrite,
        mem_MemRead,
        forward_a_control,
        forward_b_control
    );
endmodule
