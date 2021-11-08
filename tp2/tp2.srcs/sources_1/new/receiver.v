`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2021 08:23:45 PM
// Design Name: 
// Module Name: receiver
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


module receiver
#
(
    // receiver SUPPORTS:
    // DATA_SIZE VALUE FROM 6 to 8
    // STOP_BITS VALUE 1 or 2
    // PARITY 0 or 1 (only even parity)

    parameter DATA_SIZE = 8,  
    parameter STOP_BITS = 1, 
    parameter PARITY = 1 
)
(
    input wire i_clk, i_reset,
    input wire i_rx, i_boud_tick,

    output wire o_rx_done_tick,
    output wire [DATA_SIZE - 1: 0] o_data
);

    localparam frame_size = STOP_BITS + PARITY + DATA_SIZE;

    basic_receiver
    #
    (
        .DATA_SIZE(frame_size)
    ) basic_receiver
    (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_rx(i_rx),
        .i_boud_tick(i_boud_tick)
    );

    uart_reader
    #
    (
        .DATA_SIZE(DATA_SIZE),
        .PARITY(PARITY),
        .STOP_BITS(STOP_BITS)
    ) uart_reader
    (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_read_now_tick(basic_receiver.o_rx_done_tick),
        .i_frame(basic_receiver.o_data),
        .o_read_done_tick(o_rx_done_tick),
        .o_data(o_data)
    );
    
endmodule