`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2021 08:23:45 PM
// Design Name: 
// Module Name: basic_receiver
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


module basic_receiver
#
(
    // RECEIVER SUPPORTS:
    // DATA_SIZE VALUE FROM 7 to 11 (the last 1 or 2 bits are for the stop bits of the uart)

    parameter DATA_SIZE = 10 // data bits 
)
(
    input wire i_clk, i_reset,
    input wire i_rx, i_boud_tick,

    output wire o_rx_done_tick,
    output wire [DATA_SIZE - 1: 0] o_data
);

    // states alias
    localparam idle  = 5'b00001;
    localparam start = 5'b00010;
    localparam data  = 5'b00100;
    localparam stop  = 5'b01000;
    localparam error = 5'b10000;

    // semantic bit alias
    localparam start_bit = 1'b0;
    localparam stop_bit  = 1'b1;

    // count of ticks for start reading data
    localparam start_sampling_data = 4'd7;
    // count of ticks for sampling
    localparam sample_now = 4'd15;

    // signals for controlling the behavior of the automata
    reg [4 : 0] state_reg, state_next;
    reg [3 : 0] tick_counter_reg, tick_counter_next;
    reg [3 : 0] bit_counter_reg, bit_counter_next;

    // data reciever registers
    reg [DATA_SIZE - 1 : 0] data_reg, data_next;
    // done flag registers
    reg rx_done_reg, rx_done_next;

    // BODY:

    // state and data registers
    always @(posedge i_clk) begin
        if (i_reset) begin
            state_reg <= idle;
            tick_counter_reg <= 0;
            bit_counter_reg <= 0;
            data_reg <= 0;
            rx_done_reg <= 0;
        end
        else begin
            state_reg <= state_next; 
            tick_counter_reg <= tick_counter_next;
            bit_counter_reg <= bit_counter_next;
            data_reg <= data_next;
            rx_done_reg <= rx_done_next;
        end 
    end

    // next state logic

    always @(*) begin
        // init next registers
        state_next = state_reg; 
        tick_counter_next = tick_counter_reg;
        bit_counter_next = bit_counter_reg;
        data_next = data_reg;
        rx_done_next = 1'b0;

        case (state_reg)

            idle: begin
                if (i_rx == start_bit) begin
                    state_next = start;
                    tick_counter_next = 0;
                end
            end

            start: begin
            
                if (i_boud_tick) begin
                    if (tick_counter_reg == start_sampling_data) begin
                        // checks for good start_bit value 
                        if (i_rx == start_bit) begin
                            state_next = data;
                            tick_counter_next = 0;
                            bit_counter_next = 0;
                        end
                        else begin
                            state_next = error;
                        end
                    end
                    else begin
                        tick_counter_next = tick_counter_reg + 1;
                    end
                end
            end

            data: begin
                if (i_boud_tick) begin
                    if (tick_counter_reg == sample_now) begin
                        tick_counter_next = 0;
                        // shift register (shift to rigth)
                        // LSB is recieved first
                        data_next = {i_rx, data_reg[DATA_SIZE - 1 : 1]};
                        if (bit_counter_reg == (DATA_SIZE - 1)) begin
                            // reach the last bit of data
                            state_next = stop; 
                        end
                        else begin
                            // keep reading
                            bit_counter_next = bit_counter_reg + 1;
                        end
                    end
                    else begin
                        tick_counter_next = tick_counter_reg + 1;
                    end
                end
            end

            stop: begin
                // done with stop
                state_next = idle;
                // data ready to be read
                rx_done_next = 1'b1;
            end
            
            error: begin
                state_next = idle;
            end

            default: begin
                state_next = idle;
            end
        endcase
    end

    // OUTPUTS
    assign o_data = data_reg;
    assign o_rx_done_tick = rx_done_reg;

endmodule
