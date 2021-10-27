`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2021 06:02:30 PM
// Design Name: 
// Module Name: transmitter_tb
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


module transmitter_tb;
    // period
    localparam T = 10;

    localparam DATA_SIZE = 8;
    localparam SB_TICKS = 16;

    // regs for instanciating the transmitter
    reg clk, reset;
    reg tx_start, tick;
    reg [DATA_SIZE - 1: 0] data;
    wire tx_done, tx;

    transmitter
    #
    (
        .DATA_SIZE(DATA_SIZE),
        .SB_TICKS(SB_TICKS)
    ) uut
    (
        .i_clk(clk),
        .i_reset(reset),
        .i_start(tx_start),
        .i_boud_tick(tick),
        .i_data(data),
        .o_tx_done_tick(tx_done),
        .o_tx(tx)
    );

    always #(T/2) clk = ~clk;

    always begin
        #(T*163)
        tick = 1;
        #T
        tick = 0;
    end

    initial begin
        // init regs
        clk = 0;
        tx_start = 0;
        reset = 1;
        #(10*T)
        reset = 0;
        #(10*T)
        // start test
        data = 8'b00010111;
        #(10*T)
        tx_start = 1;
        #(40*T)
        tx_start = 0;
        // long wait 
        #(163*16*10*T)
        reset = 0;
    end

endmodule
