`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2021 08:23:45 PM
// Design Name: 
// Module Name: mod_m_counter
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


module mod_m_counter
#
(
    parameter N = 4, // number of bits for the counter
    parameter M = 10 // M-1 is the max number the counter counts
)
(
    input wire i_clk, i_reset,
    output wire o_tick,
    output wire [N - 1 : 0] o_count
);
    // signal declaration
    reg [N - 1 : 0] count_reg, count_next;
    reg tick_reg, tick_next;

    // BODY
    // state logic
    always @(posedge i_clk, posedge i_reset) begin
        if (i_reset) begin
            count_reg <= 0;
            tick_reg <= 0;
        end
        else begin
            count_reg <= count_next;
            tick_reg <= tick_next;
        end
    end

    // next state logic
    always @(*) begin
        // counts
        if (count_reg == (M - 1)) begin
            count_next = 0;
            tick_next = 1;
        end
        else begin
            count_next = count_reg + 1;
            tick_next = 0;
        end
    end

    // output
    assign o_count = count_reg;
    assign o_tick = tick_reg;

endmodule