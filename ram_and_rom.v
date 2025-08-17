`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2025 16:36:18
// Design Name: 
// Module Name: ram and rom
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


`timescale 1ns / 1ps

module ram_and_rom(
    input clk,
    input reset,
    input mode,         // 0 = ROM, 1 = RAM
    input we,           // Write enable (only for RAM mode)
    input [3:0] addr,   // Address (16 locations)
    input [7:0] din,    // Data input
    output reg [7:0] dout // Data output
);

    reg [7:0] memory [15:0];
    integer i;

    // Initialize ROM contents
    initial begin
        memory[0] = 8'h11;
        memory[1] = 8'h22;
        memory[2] = 8'h33;
        memory[3] = 8'h44;
        memory[4] = 8'h55;
        memory[5] = 8'h66;
        memory[6] = 8'h77;
        memory[7] = 8'h88;
        // Others default to 0
        for (i = 8; i < 16; i = i + 1)
            memory[i] = 8'h00;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dout <= 8'b0;
            if (mode) begin
                // Reset RAM contents only when in RAM mode
                for (i = 0; i < 16; i = i + 1)
                    memory[i] <= 8'b0;
            end
        end
        else begin
            if (mode) begin
                // RAM mode
                if (we)
                    memory[addr] <= din;     // Write
                else
                    dout <= memory[addr];    // Read
            end
            else begin
                // ROM mode (read-only)
                dout <= memory[addr];
            end
        end
    end
endmodule


