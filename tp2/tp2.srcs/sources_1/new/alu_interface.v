`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2021 08:23:45 PM
// Design Name: 
// Module Name: alu_interface
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


module alu_interface
#
(
    parameter DATA_SIZE = 8, // data bits
    parameter ALU_OPCODE_SIZE = 6 // must be equal or less than DATA_SIZE
)
(
    input wire i_clk, i_reset,
    input wire i_read,
    input wire [DATA_SIZE - 1: 0] i_data, i_alu_result,

    output wire o_done,
    output wire [DATA_SIZE - 1: 0] o_result,
    output wire [DATA_SIZE - 1: 0] o_data_a, o_data_b,
    output wire [ALU_OPCODE_SIZE - 1: 0] o_opcode
);

    localparam read_a  = 4'b0001;
    localparam read_b  = 4'b0010;
    localparam read_op = 4'b0100;
    localparam result  = 4'b1000;

    reg state_reg, state_next [3 : 0];

    reg done_reg, done_next;
    reg result_reg, result_next [DATA_SIZE - 1 : 0];
    reg data_a_reg, data_a_next [DATA_SIZE - 1 : 0];
    reg data_b_reg, data_b_next [DATA_SIZE - 1 : 0];
    reg opcode_reg, opcode_next [ALU_OPCODE_SIZE - 1 : 0];

    // state logic
    always @(posedge i_clk, posedge i_reset) begin
        if (i_reset) begin
            state_reg <= read_a;
            result_reg <= 0;
            data_a_reg <= 0;
            data_b_reg <= 0;
            opcode_reg <= 0;
            done_reg <= 0;
        end
        else begin
            state_reg <= state_next;
            result_reg <= result_next;
            data_a_reg <= data_a_next;
            data_b_reg <= data_b_next;
            opcode_reg <= opcode_next;
            done_reg <= done_next;
        end
    end

    // next state logic
    always @(*) begin
        // init regs
        state_next  = state_reg;
        result_next = result_reg;
        data_a_next = data_a_reg;
        data_b_next = data_b_reg;
        opcode_next = opcode_reg;
        done_next   = 1'b0;

        case (state_reg)

            read_a: begin
                if (i_read) begin
                    data_a_next = i_data;        
                    state_next = read_b;
                end
            end

            read_b: begin
                if (i_read) begin
                    data_b_next = i_data;        
                    state_next = opcode;
                end
            end

            opcode: begin
                if (i_read) begin
                    opcode_next = i_data[ALU_OPCODE_SIZE - 1: 0];        
                    state_next = done;
                end
            end

            done: begin
                result_next = i_alu_result;
                done_next = 1'b1;
            end

            default: begin
                state_next = read_a;
            end
    endcase
    end

    // OUTPUTS
    assign o_done = done_reg;
    assign o_result = result_reg;
    assign o_data_a = data_a_reg;
    assign o_data_b = data_b_reg;
    assign o_opcode = opcode_reg;

endmodule