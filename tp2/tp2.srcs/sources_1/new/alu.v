`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FCEFyN
// Engineers: Benitez - Viccini
// 
// Create Date: 09/19/2021 04:20:39 PM
// Design Name: 
// Module Name: alu
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


module alu
#
(
    parameter DATA_SIZE = 8
)
(
    input wire [DATA_SIZE - 1: 0] i_a, i_b,
    input wire [5 : 0] i_op,

    output wire [DATA_SIZE - 1: 0] o_result
);

    //  op code
    localparam      ADD     =   6'b100000;
    localparam      SUB     =   6'b100010;
    localparam      AND     =   6'b100100;
    localparam      OR      =   6'b100101;
    localparam      XOR     =   6'b100110;
    localparam      SRA     =   6'b000011;
    localparam      SRL     =   6'b000010;
    localparam      NOR     =   6'b100111;

    //  working registers
    reg [DATA_SIZE - 1: 0] result;

    // combinational logic
    always @(*) begin
        case(i_op)
        ADD: result = i_a + i_b;
        SUB: result = i_a - i_b;
        AND: result = i_a & i_b;
        OR:  result = i_a | i_b;
        XOR: result = i_a ^ i_b;
        SRA: result = $signed(i_a) >>> i_b;
        SRL: result = i_a >> i_b;
        NOR: result = ~(i_a | i_b);
        default: result = 0;
        endcase
    end
    // set outputs
    assign o_result = result;

endmodule