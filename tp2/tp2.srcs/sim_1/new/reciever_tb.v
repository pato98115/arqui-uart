`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2021 12:36:18 AM
// Design Name: 
// Module Name: reciever_tb
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


module reciever_tb;
    // period
    localparam T = 10;

    localparam DATA_SIZE = 8;
    localparam SB_TICKS = 16;

    // regs for instanciating the reciever
    reg clk, reset, rx;
    wire done, tick;
    wire [DATA_SIZE - 1: 0] data;

    receiver
    #
    (
        .DATA_SIZE(DATA_SIZE),
        .SB_TICKS(SB_TICKS)
    ) uut
    (
        .i_clk(clk),
        .i_reset(reset),
        .i_rx(rx),
        .i_boud_tick(tick),
        .o_rx_done_tick(done),
        .o_data(data)
    );

    mod_m_counter
    #
    (
        .N(8), .M(163)
    ) boud_rate_generator
    (
        .i_clk(clk), .i_reset(reset),
        .o_count(), .o_tick(tick)
    );

    always #(T/2) clk = ~clk;

    initial begin
        // init regs
        clk = 0;
        reset = 0;
        rx = 1;

        #(163*16*T)
        rx = 0;
        #(163*16*T)
        rx = 1;
        #(163*16*T)
        rx = 1;
        #(163*16*T)
        rx = 1;
        #(163*16*T)
        rx = 1;
        #(163*16*T)
        rx = 0;
        #(163*16*T)
        rx = 0;
        #(163*16*T)
        rx = 0;
        #(163*16*T)
        rx = 1;
        #(163*16*T)
        rx = 1;
    end
    
endmodule