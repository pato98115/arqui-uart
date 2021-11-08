`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2021 08:23:45 PM
// Design Name: 
// Module Name: uart_reader
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


module uart_reader
#
(
    // UART_READER SUPPORTS:
    // DATA_SIZE VALUE FROM 6 to 8
    // STOP_BITS VALUE 1 or 2
    // PARITY 0 or 1 (even parity)

    parameter DATA_SIZE = 8,  
    parameter STOP_BITS = 1, 
    parameter PARITY = 1 
)
(
    input wire i_clk, i_reset,
    input wire i_read_now_tick,
    input wire [STOP_BITS + PARITY + DATA_SIZE - 1: 0] i_frame,

    output wire o_read_done_tick,
    output wire [DATA_SIZE - 1: 0] o_data
);
    // semantic bits alias
    localparam stop_bits  = {STOP_BITS {1'b1}};

    // receiver output frame size
    localparam frame_size = STOP_BITS + PARITY + DATA_SIZE;

    // state alias
    localparam receive  = 1'b0;
    localparam done     = 1'b1;

    // signals
    reg state_reg, state_next;
    reg done_reg, done_next;

    // output auxiliar regs
    reg parity_bit;
    reg parity_ok;
    reg [DATA_SIZE - 1: 0] data_reg;
    reg [STOP_BITS - 1: 0] stop_reg;

    // read i_frame
    always @(posedge i_clk) begin
        stop_reg <= i_frame[frame_size - 1: frame_size - STOP_BITS];
        parity_bit <= i_frame[DATA_SIZE + PARITY - 1];
        data_reg <= i_frame[DATA_SIZE - 1: 0];
    end

    // set parity_ok value
    always @(posedge i_clk) begin
        if (PARITY > 0) begin
            // checks for even parity
            if ((^data_reg) == parity_bit)
                parity_ok <= 1'b1; 
            else 
                parity_ok <= 1'b0;
        end
        else begin
            parity_ok <= 1'b1;
        end
    end

    // state logic
    always @(posedge i_clk) begin
        if (i_reset) begin
            state_reg <= receive;
            done_reg <= 0;
        end
        else begin
            state_reg <= state_next;
            done_reg <= done_next;
        end
    end

    always @(*) begin
        state_next = state_reg;
        done_next = done_reg;
        case (state_reg)
            receive: begin
                done_next = 1'b0;
                if (i_read_now_tick == 1'b1) begin
                    // checks stop bits and parity
                    if (stop_reg == stop_bits && parity_ok == 1'b1) begin
                        state_next = done;
                    end
                end
            end
            done: begin
                state_next = receive;
                done_next = 1'b1;
            end
            default: begin
                state_next = receive;
            end
        endcase
    end

    //outputs
    assign o_read_done_tick = done_reg;
    assign o_data = data_reg;
    
endmodule