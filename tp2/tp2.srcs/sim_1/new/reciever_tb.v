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
    localparam STOP_BITS = 2;
    localparam PARITY = 0;

    // regs for instanciating the reciever
    reg clk, reset;
    reg rx, tick;
    wire [DATA_SIZE - 1: 0] data;
    wire done;

    receiver
    #
    (
        .DATA_SIZE(DATA_SIZE),
        .STOP_BITS(STOP_BITS),
        .PARITY(PARITY)
    ) uut
    (
        .i_clk(clk),
        .i_reset(reset),
        .i_rx(rx),
        .i_boud_tick(tick),
        .o_rx_done_tick(done),
        .o_data(data)
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
        reset = 1;
        #(10*T)
        reset = 0;
        #(10*T)
        // start test
        rx = 1;
        #(163*16*T)
        rx = 0; //start bit
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
        rx = 1; // parity bit
        #(163*16*T)
        rx = 1; // stop bit
        #(163*16*T)
        rx = 1;
        #(163*16*T)
        rx = 1;
        #(163*16*T)
        rx = 1;
        #(163*16*T)
        rx = 1;
    end
    
endmodule