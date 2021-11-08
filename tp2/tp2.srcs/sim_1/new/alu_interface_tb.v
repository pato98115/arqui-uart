`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2021 12:36:18 AM
// Design Name: 
// Module Name: alu_interface_tb
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


module alu_interface_tb;
    // period
    localparam T = 10;

    localparam DATA_SIZE = 8;
    localparam ALU_OPCODE_SIZE = 6;

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
    reg read_now;
    reg [DATA_SIZE - 1: 0] data_read;
    wire [DATA_SIZE - 1: 0] result;
    wire [ALU_OPCODE_SIZE - 1: 0] opcode;
    wire done;

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
        .i_clk(clk),
        .i_reset(reset),
        .i_read(read_now),
        .i_data(data_read),
        .i_alu_result(alu.o_result),

        .o_done(done),
        .o_result(result),
        .o_data_a(alu.i_a),
        .o_data_b(alu.i_b),
        .o_opcode(alu.i_op)
    );

    always #(T/2) clk = ~clk;

    initial begin
        // init regs
        read_now = 0;
        clk = 0;
        reset = 1;
        #(10*T)
        reset = 0;
        #(10*T)
        // start test
        data_read = 8'd3;
        read_now = 1;
        #T
        read_now = 0;
        #T
        data_read = 8'd4;
        read_now = 1;
        #T
        read_now = 0;
        #T
        data_read = {2'b00, ADD};
        read_now = 1;
        #T
        read_now = 0;
    end
    
endmodule