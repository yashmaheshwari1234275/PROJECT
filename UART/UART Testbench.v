module Uart_protocol_tb;

    // Step 1: Declare testbench signals
    reg clk_tb;
    reg reset_tb;
    reg [7:0] data_in_tb;
    reg send_tb;
    wire tx_busy_tb;

    // Step 2: Instantiate your DUT (Design Under Test)
    Uart_protocol uut (
        .clk(clk_tb),
        .reset(reset_tb),
        .data_in(data_in_tb),
        .send(send_tb),
        .tx_busy(tx_busy_tb)
    );

    // Step 3: Create stimulus (clock, inputs, etc.)
    initial begin
        // Initialize
        clk_tb = 0;
        reset_tb = 1;
        data_in_tb = 8'b10101010;
        send_tb = 0;

        // Reset pulse
        #10 reset_tb = 0;

        // Trigger transmission
        #20 send_tb = 1;
        #20 send_tb = 0;

        // Wait and observe tx_busy
        #1000 $finish;
    end

    // Clock generation
    always #5 clk_tb = ~clk_tb;  // 100MHz clock (10ns period)

endmodule
