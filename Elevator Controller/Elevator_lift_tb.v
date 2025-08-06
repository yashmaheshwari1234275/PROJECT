`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2025 13:28:58
// Design Name: 
// Module Name: Elevator_lift_tb
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


module Elevator_lift_tb;
    reg clk;
    reg reset;
    reg [2:0] req;

    // Outputs
    wire [1:0] current_floor;
    wire door_open;
    wire moving;

    // Instantiate the module
    Elevator_lift uut (
        .clk(clk),
        .reset(reset),
        .req(req),
        .current_floor(current_floor),
        .door_open(door_open),
        .moving(moving)
    );

    // Clock generation: toggle every 5ns => 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        req = 3'b000;

        // Wait for 1 clock cycle, then deassert reset
        @(posedge clk);
        reset = 0;

        $display("Time\tFloor\tDoor\tMoving\tReq");
        $monitor("%0t\t%d\t%b\t%b\t%b", $time, current_floor, door_open, moving, req);

        // Request floor 1
        @(posedge clk);
        req = 3'b010; // request floor 1

        // Wait a few cycles
        repeat(10) @(posedge clk);

        // Clear request
        req = 3'b000;

        // Wait more to observe door open
        repeat(10) @(posedge clk);

        $finish;
    end

endmodule

