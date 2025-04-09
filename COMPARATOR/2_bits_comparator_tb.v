
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 23:09:44
// Design Name: 
// Module Name: 2_bits_comparator_tb
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
`timescale 1ns / 1ps

module comparator_tb;
  reg [1:0] a, b;
  wire a_grt, b_grt, a_eq_b;

  // Instantiate the comparator module
  comparator uut (
    .a(a), 
    .b(b), 
    .a_grt(a_grt), 
    .b_grt(b_grt), 
    .a_eq_b(a_eq_b)
  );

  initial begin
    // Monitor the signals
    $monitor("Time=%0t | A=%b | B=%b | A>B=%b | A<B=%b | A==B=%b", 
              $time, a, b, a_grt, b_grt, a_eq_b);
    
    
    // Test all 2-bit combinations
    a = 2'b00; b = 2'b00; #10;  // A == B
    a = 2'b00; b = 2'b01; #10;  // A < B
    a = 2'b00; b = 2'b10; #10;  // A < B
    a = 2'b00; b = 2'b11; #10;  // A < B
    
    a = 2'b01; b = 2'b00; #10;  // A > B
    a = 2'b01; b = 2'b01; #10;  // A == B
    a = 2'b01; b = 2'b10; #10;  // A < B
    a = 2'b01; b = 2'b11; #10;  // A < B

    a = 2'b10; b = 2'b00; #10;  // A > B
    a = 2'b10; b = 2'b01; #10;  // A > B
    a = 2'b10; b = 2'b10; #10;  // A == B
    a = 2'b10; b = 2'b11; #10;  // A < B

    a = 2'b11; b = 2'b00; #10;  // A > B
    a = 2'b11; b = 2'b01; #10;  // A > B
    a = 2'b11; b = 2'b10; #10;  // A > B
    a = 2'b11; b = 2'b11; #10;  // A == B
    
    $stop; // Stop simulation
  end

endmodule
