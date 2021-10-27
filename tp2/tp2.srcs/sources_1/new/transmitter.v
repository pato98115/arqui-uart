`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2021 08:23:45 PM
// Design Name: 
// Module Name: transmitter
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


module transmitter
#
(
    // UART TRANSMITTER SUPPORTS:
    // DATA_SIZE VALUE FROM 6 to 9
    // SB_TIKS 16 (1 bit), 24 (1,5 bit) OR 32 (2 bit)

    parameter DATA_SIZE = 8, // data bits
    parameter SB_TICKS = 16  // ticks for stop bits
)
(
    input wire i_clk, i_reset,
    input wire i_start, i_boud_tick,
    input wire [DATA_SIZE - 1 : 0] i_data,

    output wire o_tx_done_tick, o_tx
);

    // states alias (4 bits because maybe needs to add a state)
    localparam idle    = 4'b0001;
    localparam sending = 4'b0010;
    // if this uart didn't supports 1,5 stop bit, the extended frame
    // can be the full frame and stop state would be alse sending state
    localparam stop    = 4'b0100;

    // semantic bit alias
    localparam start_bit = 1'b0;
    localparam stop_bit  = 1'b1;

    // count of ticks for each transmitted bit
    localparam update_tx = 4'd15;

    // extended frame size
    localparam ext_frame_size = 1 + DATA_SIZE;

    // signals for controlling the behavior of the automata
    reg [3 : 0] state_reg, state_next;
    reg [3 : 0] tick_counter_reg, tick_counter_next;
    reg [3 : 0] bit_counter_reg, bit_counter_next;

    // frame transmitter registers
    reg [ext_frame_size - 1 : 0] frame_reg, frame_next;
    reg tx_reg, tx_next;
    // done flag registers
    reg tx_done_reg, tx_done_next;

    // BODY:

    // state and data registers
    always @(posedge i_clk, posedge i_reset) begin
        if (i_reset) begin
            state_reg <= idle;
            tick_counter_reg <= 0;
            bit_counter_reg <= 0;
            frame_reg <= 1;
            tx_reg <= stop_bit;
            tx_done_reg <= 0;
        end
        else begin
            state_reg <= state_next; 
            tick_counter_reg <= tick_counter_next;
            bit_counter_reg <= bit_counter_next;
            frame_reg <= frame_next;
            tx_reg <= tx_next;
            tx_done_reg <= tx_done_next;
        end 
    end

    // next state logic

    always @(*) begin
        // init next registers
        state_next = state_reg; 
        tick_counter_next = tick_counter_reg;
        bit_counter_next = bit_counter_reg;
        frame_next = frame_reg;
        tx_next = tx_reg;
        tx_done_next = 1'b0;
        
        case (state_reg)

            idle: begin
                tx_next = stop_bit;
                if(i_start) begin
                    state_next = sending;
                    tick_counter_next = 0;
                    // build extended frame
                    frame_next = {i_data, start_bit};
                end
            end

            sending: begin
                // set bit to be send
                tx_next = frame_reg[0];
                if (i_boud_tick) begin
                    if (tick_counter_reg == update_tx) begin
                        tick_counter_next = 0;
                        // rigth shift, MSB is the last send
                        frame_next = frame_reg >> 1;
                        if (bit_counter_reg == (ext_frame_size - 1)) begin
                            state_next = stop;
                        end
                        else begin
                            bit_counter_next = bit_counter_reg + 1;
                        end
                    end
                    else begin
                        tick_counter_next = tick_counter_reg + 1;
                    end
                end
            end

            stop: begin
                tx_next = stop_bit;
                if (i_boud_tick) begin
                    if (tick_counter_reg == (SB_TICKS - 1)) begin
                        // done with stop
                        state_next = idle;
                        // done with this frame
                        tx_done_next = 1'b1;
                    end
                    else begin
                        tick_counter_next = tick_counter_reg + 1;
                    end
                end
            end

            default: begin
                state_next = idle;
            end
        endcase
    end

    // OUTPUTS
    assign o_tx = tx_reg;
    assign o_tx_done_tick = tx_done_reg;

endmodule