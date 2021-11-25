`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2021 08:23:45 PM
// Design Name: 
// Module Name: uart
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


module uart
#
(
    // UART SUPPORTS:
    // DATA_SIZE VALUE FROM 6 to 8
    // STOP_BITS VALUE 1 or 2
    // PARITY 0 or 1 (even parity)
    // this doesn't calculates parity for transmitting, only checks it when receiving

    parameter DATA_SIZE = 8,  
    parameter STOP_BITS = 1, 
    parameter PARITY = 1
)
(
    input wire i_clk, i_reset,
    input wire i_rx,
    input wire i_tx_start,
    input wire [DATA_SIZE + PARITY - 1: 0] i_tx_bus,

    output wire o_tx,
    output wire [DATA_SIZE + PARITY - 1: 0] o_rx_bus,
    output wire o_rx_done_tick,
    output wire o_tx_done_tick
);
    localparam CLK_DIV = 163;
    localparam DIV_SIZE = 8;
    
    wire tick;

    mod_m_counter
    # 
    (
        .M(CLK_DIV),
        .N(DIV_SIZE)
    ) boud_rate_generator
    (
        .i_clk(i_clk),
        .i_reset(i_reset),
        
        .o_tick(tick)
    );

    receiver
    # 
    (
        .DATA_SIZE(DATA_SIZE),
        .PARITY(PARITY),
        .STOP_BITS(STOP_BITS)
    ) receiver
    (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_boud_tick(tick),
        .i_rx(i_rx),
        .o_rx_done_tick(o_rx_done_tick),
        .o_data(o_rx_bus)
    );

    transmitter
    # 
    (
        .DATA_SIZE(DATA_SIZE + PARITY),
        .STOP_BITS(STOP_BITS)
    ) transmitter
    (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_boud_tick(tick),
        .i_start(i_tx_start),
        .i_data(i_tx_bus),
        .o_tx_done_tick(o_tx_done_tick),
        .o_tx(o_tx)
    );

endmodule