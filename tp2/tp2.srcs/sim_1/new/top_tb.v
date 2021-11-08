`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2021 12:36:18 AM
// Design Name: 
// Module Name: top_tb
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


module top_tb;
    // period
    localparam T = 10;

    localparam DATA_SIZE = 8;
    localparam STOP_BITS = 2;
    localparam PARITY = 0;

    //  op code
    localparam      ADD     =   6'b100000;
    localparam      SUB     =   6'b100010;
    localparam      AND     =   6'b100100;
    localparam      OR      =   6'b100101;
    localparam      XOR     =   6'b100110;
    localparam      SRA     =   6'b000011;
    localparam      SRL     =   6'b000010;
    localparam      NOR     =   6'b100111;

    // regs for tests the uart
    reg clk, reset;
    reg tx_start;
    reg [DATA_SIZE - 1: 0] tx_bus;
    wire [DATA_SIZE - 1: 0] rx_bus;
    wire rx_done;

    uart
    #
    (
        .DATA_SIZE(DATA_SIZE),
        .STOP_BITS(STOP_BITS),
        .PARITY(PARITY)
    ) uart
    (
        .i_clk(clk),
        .i_reset(reset),
        .i_rx(),
        .i_tx_start(tx_start),
        .i_tx_bus(tx_bus),

        .o_tx(),
        .o_rx_bus(rx_bus),
        .o_rx_done_tick(rx_done),
        .o_tx_done_tick()
    );

    top
    #
    (
        .DATA_SIZE(DATA_SIZE),
        .STOP_BITS(STOP_BITS),
        .PARITY(PARITY)
    ) top
    (
        .i_clk(clk),
        .i_reset(reset),
        .i_rx(uart.o_tx),

        .o_tx(uart.i_rx)
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
        // data_a
        tx_bus = 8'b00000001;
        #(10*T)
        tx_start = 1;
        #(30*T)
        tx_start = 0;
        #(40000*T)
        //data_b
        tx_bus = 8'b00000010;
        #(10*T)
        tx_start = 1;
        #(30*T)
        tx_start = 0;
        #(40000*T)
        //op_code
        tx_bus = {2'b00, ADD};
        #(10*T)
        tx_start = 1;
        #(30*T)
        tx_start = 0;
    end
    
endmodule