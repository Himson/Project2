`timescale 1ns / 1ps

module single(
    input   clock,
    input   cycle,
    input   [4:0]RegisterIndex,        
    output  [3:0]Anodes,
    output  [6:0]Cathodes,
    output  reg[4:0]count,
    output  wb_regwrite
    );
    // reg cycle = 1;
    reg harzard_detection2pc_stall;
    // reg [4:0]RegisterIndex;
//    always #50 cycle = ~cycle;
    initial begin  
        #0 harzard_detection2pc_stall = 0;
        #3000 $finish;
    end
    wire [4:0] rs, rt, rd, writerd;
    wire [31:0]alu_result, actual_alu_rt,signexten, branchaddress, memory_readdata, branch_or_not_addr, jump_addr, instru, writedata, rsdata, rtdata, next_instruction_addr, current_instru_addr, current_instru_addr_plus4;
    wire [1:0] ALUOp;
    wire Regdst, Jump, beq, bne, MemRead, MemtoReg,  MemWrite, ALUsrc, RegWrite, aluzero;
    wire [27:0] jump_addr_shift2;
    wire branch_control;
    wire [3:0] ALUControl;
    assign branch_control = (beq&&aluzero)||(bne&&(!aluzero));
    assign branch_or_not_addr = (branch_control)?branchaddress:current_instru_addr_plus4;
    assign next_instruction_addr = (Jump)?jump_addr:branch_or_not_addr;
    assign current_instru_addr_plus4 = current_instru_addr + 4;
    assign jump_addr_shift2 = instru[25:0] << 2;
    assign branchaddress = current_instru_addr_plus4 + (signexten<<2) ;
    assign signexten = {{16{instru[15]}}, instru[15:0]};
    assign actual_alu_rt = (ALUsrc)?signexten:rtdata;
    assign rs = instru[25:21];
    assign rt = instru[20:16];
    assign rd = instru[15:11];
    assign jump_addr = {current_instru_addr_plus4[31:28], jump_addr_shift2};
    assign writedata = (MemtoReg)?memory_readdata:alu_result;
    assign writerd = (Regdst)?rd:rt;
    ProgramCounter pc(
        cycle,
        next_instruction_addr,
        harzard_detection2pc_stall,
        current_instru_addr
    );
    InstructionMemory im(
        current_instru_addr,
        instru
    );
    wire [31:0] number;
    RF_fpga RF(
        cycle,
        rs,
        rt,
        writerd,
        writedata,
        RegWrite,
        RegisterIndex,
        rsdata,
        rtdata,
        number
    );
    ALUcontrol alucontrol(
        ALUOp,
        signexten[5:0],
        ALUControl
    );    
    control Control(
        instru,
        Regdst,
        Jump,
        beq,
        bne,
        MemRead,
        MemtoReg,
        ALUOp,
        MemWrite,
        ALUsrc,
        RegWrite
    ); 
    ALU alu(
        rsdata,
        actual_alu_rt,
        ALUControl,
        aluzero,
        alu_result
    );
    DataMemory dm(
        alu_result,
        MemWrite,
        MemRead,
        rtdata,
        memory_readdata
    );
    // integer i = 0;
    // always #50 begin
    //     $display("Time: %d, cycle = %d, PC = 0x%H", i, cycle, next_instruction_addr);
    //     $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", RF.register[16], RF.register[17], RF.register[18]);
    //     $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", RF.register[19], RF.register[20], RF.register[21]);
    //     $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", RF.register[22], RF.register[23], RF.register[8]);
    //     $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", RF.register[9], RF.register[10], RF.register[11]);
    //     $display("MEM[1] = 0x%H, MEM[8] = 0x%H",dm.memory[1],dm.memory[8]);
    //     $display("----------------------------------------------------------");
    //     cycle = ~cycle;
    //     if (cycle) i = i + 1;
    // end
    assign wb_regwrite = RegWrite;
    SSD_Display Test1 (
           .clock(clock), 
           .number_32(number), 
           .Cathodes(Cathodes), 
           .Anodes(Anodes)
     );
endmodule