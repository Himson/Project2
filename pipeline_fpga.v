`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2019 09:08:17 PM
// Design Name: 
// Module Name: pipeline_fpga
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

module pipeline_fpga(
    input   clock,
    input   cycle,
    input   [4:0]RegisterIndex,        
    output  [3:0]Anodes,
    output  [6:0]Cathodes,
    output  reg[4:0]count,
    output  wb_regwrite
    );
    initial #0 begin
        count = 5'b00001;
    end
    always@(posedge cycle) count = count + 1;
    wire [31:0] if_current_instru_addr_plus4;
    wire [31:0] ifbranchorjump;
    wire [31:0] next_instruction_addr;
    wire if_pcmux_control;
    mux2to1 pcincomemux(
      .port0(if_current_instru_addr_plus4),
      .port1(ifbranchorjump),
      .control(if_pcmux_control),
      .out(next_instruction_addr)
    );
    wire harzard_detection2pc_stall;
    wire [31:0] current_instru_addr;
    ProgramCounter pc(
        cycle,
        next_instruction_addr,
        harzard_detection2pc_stall,
        current_instru_addr
    );
    wire [31:0] if_current_instru;
    InstructionMemory im(
        current_instru_addr,
        if_current_instru
    );
    assign if_current_instru_addr_plus4 = current_instru_addr+4;
    //wire ifflush;
    wire [31:0] id_instru;
    wire [31:0] id_instru_addr_plus4;
    IFID ifid(
        .clk(cycle),
        .instruction(if_current_instru),
        .instru_addr_plus4(if_current_instru_addr_plus4),
        .stall(harzard_detection2pc_stall),
        .instru_out(id_instru),
        .instru_addr_plus4_out(id_instru_addr_plus4) 
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
        id_instru,
        idRegdst,
        idJump,
        idbeq,
        idbne,
        idMemRead,
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
    wire [31:0] number;
    RF_fpga RF(
        .clk(cycle),
        .rs(idrs),
        .rt(idrt),
        .writeaddr(wbrd),
        .writedata(wb_write_to_reg_data),
        .regwrite(wbregwrite),
        .index(RegisterIndex),
        .rsdata(idrsdata),
        .rtdata(idrtdata),
        .number(number)
    );
    wire idequal;
    wire branch_hazard_rs_control;
    wire branch_hazard_rt_control;
    wire [31:0] to_compare_rt;
    wire [31:0] to_compare_rs;
    wire [31:0] mem_alu_result;
    mux2to1 forward_branch_hazard_rs(
        idrsdata,
        mem_alu_result,
        branch_hazard_rs_control,
        to_compare_rs
    );
    mux2to1 forward_branch_hazard_rt(
        idrtdata,
        mem_alu_result,
        branch_hazard_rt_control,
        to_compare_rt
    );

    assign idequal = (to_compare_rt==to_compare_rs);
    wire branch_or_not;
    assign branch_or_not = (idbeq&&idequal)||(idbne&&!idequal);
    wire [27:0] id_instru_jump_addr_shift2;
    assign id_instru_jump_addr_shift2 = id_instru[25:0] << 2;
    wire [31:0] jump_addr = {id_instru_addr_plus4[31:28], id_instru_jump_addr_shift2};   
    assign if_pcmux_control = idJump||branch_or_not;
    mux2to1 id_jump_or_branch_mux(
        branchaddress,
        jump_addr,
        idJump,
        ifbranchorjump
    );
    wire [4:0] exrs;
    wire [4:0] exrt;
    wire [4:0] exrd;
    wire exRegdst;
    wire exMemRead;
    wire exMemtoReg;
    wire [1:0] exALUOp;
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
        .clk(cycle),
        .flush(harzard_detection_id_flush),
        .rs(idrs),
        .rt(idrt),
        .rd(idrd),
        .Regdst(idRegdst),
        .MemRead(idMemRead),
        .MemtoReg(idMemtoReg),
        .ALUOp(idALUOp),
        .MemWrite(idMemWrite),
        .ALUsrc(idALUsrc),
        .RegWrite(idRegWrite),
        .Immediate(signexten),
        .read1(idrsdata),
        .read2(idrtdata),
        .rsout(exrs),
        .rtout(exrt),
        .rdout(exrd),
        .Regdstout(exRegdst),
        .MemReadout(exMemRead),
        .MemtoRegout(exMemtoReg),
        .ALUOpout(exALUOp),
        .MemWriteout(exMemWrite),
        .ALUsrcout(exALUsrc),
        .RegWriteout(exRegWrite),
        .Immediateout(exImmediate),
        .read1out(exrsdata),
        .read2out(exrtdata)
    );
    wire aluzero;
    wire [31:0] ex_alu_result;
    wire [31:0] ex_forwarded_rsdata;
    wire [31:0] ex_forwarded_rtdata;
    wire [31:0] ex_forwarded_or_immediate_rtdata;
    wire [1:0] forward_a_control;
    wire [1:0] forward_b_control;
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
        exRegdst,
        ex_writeback_rd
    );
    
    ALU alu(
        ex_forwarded_rsdata,
        ex_forwarded_or_immediate_rtdata,
        exALUControl,
        aluzero,
        ex_alu_result
    );
    wire [4:0] mem_rd;
    wire mem_MemRead;
    wire mem_MemtoReg;
    wire mem_MemWrite;
    wire mem_RegWrite;
    wire [31:0] mem_forwarded_rtdata;

    EXMEM exmem(
        .clk(cycle),
        .aluresult(ex_alu_result),
        .rd(ex_writeback_rd),
        .MemRead(exMemRead),
        .MemtoReg(exMemtoReg),
        .MemWrite(exMemWrite),
        .RegWrite(exRegWrite),
        .ex_forwarded_rtdata(ex_forwarded_rtdata),
        .aluresultout(mem_alu_result),
        .rdout(mem_rd),
        .MemReadout(mem_MemRead),
        .MemtoRegout(mem_MemtoReg),
        .MemWriteout(mem_MemWrite),
        .RegWriteout(mem_RegWrite),
        .mem_forwarded_rtdata(mem_forwarded_rtdata)
    );
    
    wire [31:0] mem_memory_readdata;
    DataMemory dm(
        cycle,
        mem_alu_result,
        mem_MemWrite,
        mem_MemRead,
        mem_forwarded_rtdata,
        mem_memory_readdata
    );
    wire [31:0] wb_alu_result;
    wire [31:0] wb_memory_readdata;
    wire wb_MemtoReg;
    MEMWB memwb(
        .clk(cycle),
        .aluresult(mem_alu_result),
        .memreadresult(mem_memory_readdata),
        .rd(mem_rd),
        .Regwrite(mem_RegWrite),
        .MemtoReg(mem_MemtoReg),
        .aluresultout(wb_alu_result),
        .memreadresultout(wb_memory_readdata),
        .rdout(wbrd),
        .Regwriteout(wbregwrite),
        .MemtoRegout(wb_MemtoReg)
    );
    mux2to1 Mem_or_alu_to_Reg_mux(
        wb_alu_result,
        wb_memory_readdata,
        wb_MemtoReg,
        wb_write_to_reg_data
    );
    hazarddetection hd(
        .beq(idbeq),
        .bne(idbne),
        .idrs(idrs),
        .idrt(idrt),
        .idalusrc(idALUsrc),
        .exregwrite(exRegWrite),
        .exMemRead(exMemRead),
        .exrd(ex_writeback_rd),
        .memregwrite(mem_RegWrite),
        .memrd(mem_rd),
        .mem_MemtoReg(mem_MemtoReg),
        .idflush(harzard_detection_id_flush),
        .stall(harzard_detection2pc_stall),
        .forward1(branch_hazard_rs_control),
        .forward2(branch_hazard_rt_control)      
    );
    forwardunit forward(
        exrs,
        exrt,
        mem_rd,
        wbrd,
        exRegdst,
        mem_RegWrite,
        wbregwrite,
        mem_MemRead,
        forward_a_control,
        forward_b_control
    );
    
//    reg [31:0] test = 32'h00000020;
//    reg [31:0] test;
//    initial begin 
//    #0 test <=32'h0;
//    #1 test = cycle;
//    end
//    always @(cycle) test = cycle;
    assign wb_regwrite = wbregwrite;
     SSD_Display Test1 (
           .clock(clock), 
           .number_32(number), 
           .Cathodes(Cathodes), 
           .Anodes(Anodes)
     );
endmodule
