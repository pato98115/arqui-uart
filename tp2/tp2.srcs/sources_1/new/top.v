`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2021 08:23:45 PM
// Design Name: 
// Module Name: top
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


module top
#
(
    parameter DATA_SIZE = 8,
    parameter STOP_BITS = 1,
    parameter PARITY = 0,
    parameter ALU_OPCODE_SIZE = 6 // this is actually fixed because our alu only has 6 bits opcode

)
(
    input wire i_clk, i_reset,
    input wire i_rx,

    output wire o_tx,
    output wire o_done
);
    
    wire [DATA_SIZE - 1: 0] alu_result_to_interface_alu_result;
    
    wire [DATA_SIZE - 1: 0] interface_data_a_to_alu_a;
    wire [DATA_SIZE - 1: 0] interface_data_b_to_alu_b;
    wire [ALU_OPCODE_SIZE - 1: 0] interface_opcode_to_alu_op;
    wire interface_done_to_uart_tx_start;
    wire [DATA_SIZE - 1: 0] interface_result_to_uart_tx_bus;
    
    wire [DATA_SIZE - 1: 0] uart_rx_bus_to_interface_data;
    wire uart_rx_done_tick_to_interface_read;

    alu
    # 
    (
        .DATA_SIZE(DATA_SIZE)
    ) alu
    (
        .i_a(interface_data_a_to_alu_a),
        .i_b(interface_data_b_to_alu_b),
        .i_op(interface_opcode_to_alu_op),

        .o_result(alu_result_to_interface_alu_result)
    );

    alu_interface
    # 
    (
        .DATA_SIZE(DATA_SIZE),
        .ALU_OPCODE_SIZE(ALU_OPCODE_SIZE)
    ) alu_interface
    (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_read(uart_rx_done_tick_to_interface_read),
        .i_data(uart_rx_bus_to_interface_data),
        .i_alu_result(alu_result_to_interface_alu_result),

        .o_done(interface_done_to_uart_tx_start),
        .o_result(interface_result_to_uart_tx_bus),
        .o_data_a(interface_data_a_to_alu_a),
        .o_data_b(interface_data_b_to_alu_b),
        .o_opcode(interface_opcode_to_alu_op)
    );

    uart
    #
    (
        .DATA_SIZE(DATA_SIZE),
        .STOP_BITS(STOP_BITS),
        .PARITY(PARITY)
    ) uart
    (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_rx(i_rx),
        .i_tx_start(interface_done_to_uart_tx_start),
        .i_tx_bus(interface_result_to_uart_tx_bus),

        .o_tx(o_tx),
        .o_rx_bus(uart_rx_bus_to_interface_data),
        .o_rx_done_tick(uart_rx_done_tick_to_interface_read),
        .o_tx_done_tick(o_done)
    );

endmodule