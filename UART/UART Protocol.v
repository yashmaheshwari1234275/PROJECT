`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// UART Protocol Top Module with Baud Generator, TX, and RX
//////////////////////////////////////////////////////////////////////////////////

module Uart_protocol (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire send,
    input wire rx,
    output wire tx,
    output wire [7:0] data_out,
    output wire rx_done,
    output wire tx_busy
);

    wire tick;

    // Baud Generator Instance
    baud_gen #(.BAUD_DIV(10416)) baud_inst (
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

    // UART Transmitter
    uart_tx tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(send),
        .tx_data(data_in),
        .tick(tick),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // UART Receiver
    uart_rx rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tick(tick),
        .rx_data(data_out),
        .rx_done(rx_done)
    );

endmodule

//////////////////////////////////////////////////////////////////////////////////
// Baud Generator Module
//////////////////////////////////////////////////////////////////////////////////

module baud_gen #(
    parameter BAUD_DIV = 10416
) (
    input wire clk,
    input wire reset,
    output reg tick
);
    reg [13:0] count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            tick <= 0;
        end else if (count == BAUD_DIV - 1) begin
            count <= 0;
            tick <= 1;
        end else begin
            count <= count + 1;
            tick <= 0;
        end
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
// UART Transmitter
//////////////////////////////////////////////////////////////////////////////////

module uart_tx (
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire [7:0] tx_data,
    input wire tick,
    output reg tx,
    output reg tx_busy
);
    reg [3:0] bit_index;
    reg [9:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1;
            tx_busy <= 0;
            bit_index <= 0;
            shift_reg <= 10'b1111111111;
        end else if (tx_start && !tx_busy) begin
            shift_reg <= {1'b1, tx_data, 1'b0}; // stop + data + start
            tx_busy <= 1;
            bit_index <= 0;
        end else if (tick && tx_busy) begin
            tx <= shift_reg[0];
            shift_reg <= {1'b1, shift_reg[9:1]};
            bit_index <= bit_index + 1;
            if (bit_index == 9)
                tx_busy <= 0;
        end
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
// UART Receiver
//////////////////////////////////////////////////////////////////////////////////

module uart_rx (
    input wire clk,
    input wire reset,
    input wire rx,
    input wire tick,
    output reg [7:0] rx_data,
    output reg rx_done
);

    reg [3:0] bit_index = 0;
    reg [7:0] shift_reg = 0;
    reg [1:0] state = 0;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_index <= 0;
            shift_reg <= 0;
            rx_done <= 0;
        end else begin
            rx_done <= 0;
            case (state)
                IDLE: begin
                    if (!rx)
                        state <= START;
                end
                START: begin
                    if (tick)
                        state <= DATA;
                end
                DATA: begin
                    if (tick) begin
                        shift_reg[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                        if (bit_index == 7)
                            state <= STOP;
                    end
                end
                STOP: begin
                    if (tick) begin
                        rx_data <= shift_reg;
                        rx_done <= 1;
                        bit_index <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule


