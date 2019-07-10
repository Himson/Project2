`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2019 08:55:17 PM
// Design Name: 
// Module Name: ssddriver
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


module ssddriver(
    input  [3:0]   in,
    output reg[6:0]out
);
    initial begin
        out = 7'b1111111;
    end
    always @(*) begin
        case (in)
            4'h0:out = 7'b0000001;
            4'h1:out = 7'b1001111;
            4'h2:out = 7'b0010010;
            4'h3:out = 7'b0000110;
            4'h4:out = 7'b1001100;
            4'h5:out = 7'b0100100;
            4'h6:out = 7'b0100000;
            4'h7:out = 7'b0001111;
            4'h8:out = 7'b0000000;
            4'h9:out = 7'b0000100;
            4'ha:out = 7'b0001000;
            4'hb:out = 7'b1100000;
            4'hc:out = 7'b0110001;
            4'hd:out = 7'b1000010;
            4'he:out = 7'b0110000;
            4'hf:out = 7'b0111000;
            default: 
                 out = 7'b1111111;
        endcase
    end
endmodule

module Divider_100M_to_500(clock, Output_clock);
    input clock;
    output Output_clock;
    reg Output_clock;
    reg [17:0] Counter;
    
    initial begin #0 Counter = 0; Output_clock = 0; end
        
    always @ (posedge clock)   begin
        if (Counter == 199999) begin Output_clock <= 1; Counter <= 0;  end
        else if (Counter == 1) begin  Output_clock <= 0; Counter <= Counter + 1;  end
        else Counter <= Counter + 1;   
    end
endmodule
module Divide_500_to_1 (clock, Output_clock);
    input clock;
    output Output_clock;
    reg Output_clock;
    reg [8:0] Counter;
    
    initial begin #0 Counter = 0; Output_clock = 0;  end
    
    always @ (posedge clock)   begin
        if (Counter == 499)    begin Output_clock <= 1; Counter <= 0;  end
        else if (Counter == 1)  begin  Output_clock <= 0; Counter <= Counter + 1; end
        else Counter <= Counter + 1;
    end

endmodule

// module Ring_Counter
// EFFECT: 用于计数, counter 满了之�?�会自动回到 0
module Ring_Counter(
    input   wire            clock,
    output  reg     [1:0]   counter
);
    initial begin
        counter = 2'd0;
    end

    always @ (posedge clock)    begin
        counter = counter + 1;
    end
endmodule

// module SSD_Display
// EFFECT: 
//      - 输入一个 16 bits 的数字，在 SSD 上展示
//      - 实质上这里输入的clock必须是FPGA自带的clock
module SSD_Display(
    input   wire            clock,
    input   wire    [31:0]  number_32,
    output  wire    [6:0]   Cathodes,
    output  reg     [3:0]   Anodes
);
    wire clock_500Hz, clock_1Hz;
    wire [1:0]  counter;
    reg [3:0]  Q;
    wire [15:0] number = number_32[15:0];
    initial begin
        Q = 4'b0000;
        Anodes = 4'b1111;
    end

    Divider_100M_to_500 Test1 (
        .clock(clock), .Output_clock(clock_500Hz)
    );
    Divide_500_to_1 Test2 (
        .clock(clock_500Hz), .Output_clock(clock_1Hz)
    );

    Ring_Counter Test3 (
        .clock(clock_500Hz), .counter(counter)
    );

    always @ ( * ) begin
        case (counter)
            2'b00: begin
                Q = number[15:12];
                Anodes = 4'b0111;
            end
            2'b01: begin
                Q = number[11:8];
                Anodes = 4'b1011;
            end
            2'b10: begin
                Q = number[7:4];
                Anodes = 4'b1101;
            end
            2'b11: begin
                Q = number[3:0];
                Anodes = 4'b1110;
            end
            default: begin
                Q = 4'b0000;
                Anodes = 4'b1111;
            end
        endcase
    end

    ssddriver ssd_driver (
        .in(Q), .out(Cathodes)
    );

endmodule