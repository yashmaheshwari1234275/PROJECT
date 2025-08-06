`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2025 12:58:30
// Design Name: 
// Module Name: Elevator_lift
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


module Elevator_lift(
    input clk,
    input reset,
    input [2:0] req,              // floor requests: req[0], req[1], req[2]
    output reg [1:0] current_floor, // current floor (0 to 2)
    output reg door_open,         // door open signal
    output reg moving             // elevator moving signal
);

    // Define states using parameters (no enum)
    parameter IDLE      = 2'b00;
    parameter MOVE_UP   = 2'b01;
    parameter MOVE_DOWN = 2'b10;
    parameter DOOR_OPEN = 2'b11;

    reg [1:0] state;       // current state
    reg [1:0] next_state;  // next state

    // State update block (sequential)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            current_floor <= 2'd0; // start at ground floor
        end else begin
            state <= next_state;
        end
    end

    // FSM logic (combinational)
    always @(*) begin
        // default values
        next_state = state;
        door_open = 0;
        moving = 0;

        case (state)
            IDLE: begin
                if (req[current_floor]) begin
                    next_state = DOOR_OPEN; // if request at current floor
                end else if (|req) begin
                    // move up or down based on simple logic
                    if (current_floor < 2 && (req[2] || (req[1] && current_floor < 1)))
                        next_state = MOVE_UP;
                    else if (current_floor > 0 && (req[0] || (req[1] && current_floor > 1)))
                        next_state = MOVE_DOWN;
                end
            end

            MOVE_UP: begin
                moving = 1;
                next_state = IDLE;
            end

            MOVE_DOWN: begin
                moving = 1;
                next_state = IDLE;
            end

            DOOR_OPEN: begin
                door_open = 1;
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Update floor based on move direction
    always @(posedge clk) begin
        if (state == MOVE_UP && current_floor < 2)
            current_floor <= current_floor + 1;
        else if (state == MOVE_DOWN && current_floor > 0)
            current_floor <= current_floor - 1;
    end

endmodule
