`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 00:20:55
// Design Name: 
// Module Name: FIFO
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


// Code your design here
module FIFO (
    input clk,
    input reset,
    input read,
    input write,
    input [7:0] buff_in,
    output reg [7:0] buff_out,
    output reg full,
    output reg empty,
    output reg [7:0] fifo_count
);

  reg [5:0] read_p, write_p; // 6 bits for 64-depth FIFO
  reg [7:0] memory [63:0];   // FIFO memory

  // Update FIFO flags based on count
  always @(*) begin
    empty = (fifo_count == 0);
    full  = (fifo_count == 64);
  end

  // FIFO counter
  always @(posedge clk or posedge reset) begin
    if (reset)
      fifo_count <= 0;
    else if (!full && write && !read)
      fifo_count <= fifo_count + 1;
    else if (!empty && read && !write)
      fifo_count <= fifo_count - 1;
    // if both read & write, count stays same
  end

  // Reading from FIFO
  always @(posedge clk or posedge reset) begin
    if (reset)
      buff_out <= 0;
    else if (!empty && read)
      buff_out <= memory[read_p];
  end

  // Writing to FIFO
  always @(posedge clk) begin
    if (write && !full)
      memory[write_p] <= buff_in;
  end

  // Update read/write pointers
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      read_p <= 0;
      write_p <= 0;
    end else begin
      if (!full && write)
        write_p <= write_p + 1;
      if (!empty && read)
        read_p <= read_p + 1;
    end
  end

endmodule

