`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 23:06:14
// Design Name: 
// Module Name: 2_bit-comparator
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


module comparator(a_grt, b_grt, a_eq_b, a, b);
  input [1:0] a, b;
  output a_grt, b_grt, a_eq_b;
  wire w1, w2, w3, w4, w5, w6, w7, w8;

  // Equality check
  xnor u1(w1, b[1], a[1]);
  xnor u2(w2, b[0], a[0]);
  and u3(a_eq_b, w1, w2);

  // A > B check
  assign w3 = ~b[1] & a[1];
  assign w4 = a[1] & a[0] & ~b[0];
  assign a_grt = w3 | w4;

  // B > A check
  assign w5 = ~a[1] & b[1];
  assign w6 = b[1] & b[0] & ~a[0];
  assign b_grt = w5 | w6;

endmodule
