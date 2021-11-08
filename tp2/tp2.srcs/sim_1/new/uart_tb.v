`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2021 12:36:18 AM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb;
    // period
    localparam T = 10;

    localparam DATA_SIZE = 8;
    localparam STOP_BITS = 2;
    localparam PARITY = 0;

    // regs for tests the uart
    reg clk, reset;
    reg tx_start;
    reg [DATA_SIZE - 1: 0] tx_bus;
    wire [DATA_SIZE - 1: 0] rx_bus;
    wire rx_done;

    wire rx_done_tx_start;
    wire [DATA_SIZE - 1: 0] rx_bus_tx_bus;

    uart
    #
    (
        .DATA_SIZE(DATA_SIZE),
        .STOP_BITS(STOP_BITS),
        .PARITY(PARITY)
    ) uart_a
    (
        .i_clk(clk),
        .i_reset(reset),
        .i_tx_start(tx_start),
        .i_tx_bus(tx_bus),

        .o_rx_bus(rx_bus),
        .o_rx_done_tick(rx_done)
    );

    uart
    #
    (
        .DATA_SIZE(DATA_SIZE),
        .STOP_BITS(STOP_BITS),
        .PARITY(PARITY)
    ) uart_b
    (
        .i_clk(clk),
        .i_reset(reset),
        .i_rx(uart_a.o_tx),
        .i_tx_start(rx_done_tx_start),
        .i_tx_bus(rx_bus_tx_bus),

        .o_tx(uart_a.i_rx),
        .o_rx_bus(rx_bus_tx_bus),
        .o_rx_done_tick(rx_done_tx_start)
    );

    always #(T/2) clk = ~clk;

    initial begin
        // init regs
        clk = 0;
        reset = 1;
        #(10*T)
        reset = 0;
        #(10*T)
        // start test
        tx_bus = 8'b10001111;
        #(10*T)
        tx_start = 1;
        #(40*T)
        tx_start = 0;
    end
    
endmodule