`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 00:33:50
// Design Name: 
// Module Name: synchronus_fifo_tb
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


// Code your testbench here
// or browse Examples
module synchronus_fifo_tb;

  reg clk = 0, reset, read, write;
  reg [7:0] buff_in;
  wire [7:0] buff_out;
  wire full, empty;
  wire [7:0] fifo_count;

  FIFO uut (
    .clk(clk), .reset(reset), .read(read), .write(write),
    .buff_in(buff_in), .buff_out(buff_out),
    .full(full), .empty(empty), .fifo_count(fifo_count)
  );

  // Clock generator
  always #5 clk = ~clk;

  initial begin
    // Monitor output
    $monitor("Time=%0t  : clk=%b  : reset=%b : write=%b : read=%b : buff_in=%h : buff_out=%h : fifo_count=%d : full=%b : empty=%b",
             $time, clk, reset, write, read, buff_in, buff_out, fifo_count, full, empty);

    // Test sequence
    reset = 1; write = 0; read = 0; buff_in = 0;
    #10 reset = 0;

    // Write some data
    repeat(5) begin
      write = 1;
      buff_in = $random;
      #10;
    end

    write = 0;

    // Read data back
    repeat(5) begin
      read = 1;
      #10;
    end

    read = 0;
    #20 $finish;
  end

endmodule

