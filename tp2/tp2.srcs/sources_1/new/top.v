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

    output wire o_tx
);

    alu
    # 
    (
        .DATA_SIZE(DATA_SIZE)
    ) alu
    (
        .i_a(),
        .i_b(),
        .i_op(),

        .o_result()
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
        .i_read(),
        .i_data(),
        .i_alu_result(alu.o_result),

        .o_done(),
        .o_result(),
        .o_data_a(alu.i_a),
        .o_data_b(alu.i_b),
        .o_opcode(alu.i_op)
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
        .i_tx_start(alu_interface.o_done),
        .i_tx_bus(alu_interface.o_result),

        .o_tx(o_tx),
        .o_rx_bus(alu_interface.i_data),
        .o_rx_done_tick(alu_interface.i_read),
        .o_tx_done_tick()
    );

endmodule