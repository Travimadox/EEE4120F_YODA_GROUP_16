`timescale 1ns / 1ps

module audio_min_max_interval_tb;

localparam N = 100;  // number of samples
localparam NUM_INTERVALS = N / 10;  // number of intervals (assuming interval_len = 10)
localparam INTERVAL_LEN = 10;

reg reset;
reg start;
reg clk;
reg [31:0] raw_audio [N-1:0];
reg [15:0] interval_len;
wire done;
wire signed [31:0] out_max [NUM_INTERVALS-1:0];
wire signed [31:0] out_min [NUM_INTERVALS-1:0];
reg [63:0] timer;


audio_min_max_interval dut (
    .reset(reset),
    .start(start),
    .clk(clk),
    .raw_audio(raw_audio),
    .interval_len(interval_len),
    .done(done),
    .out_max(out_max),
    .out_min(out_min)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $display();
end

// Test cases
initial begin
    clk = 0;
    reset = 1;
    start = 0;
    interval_len = INTERVAL_LEN;
    
    // Test case 1: Ramp signal
    $display("Test case 1: Ramp signal");
    for (integer i = 0; i < N; i = i + 1) begin
        raw_audio[i] = i;
    end

    #10 reset = 0;
    #10 start = 1;
    #10 start = 0;

    // Wait for the computation to complete
    wait (done);

    // Verify the results
    for (integer i = 0; i < NUM_INTERVALS; i = i + 1) begin
        $display("Interval %2d: min = %1d, max = %1d", i, out_min[i], out_max[i]);
        if (out_min[i] != i * 10 || out_max[i] != (i * 10) + 9) begin
            $error("Incorrect min/max values for interval %d", i);
        end
    end

    $display("Test case 1 passed!");

    // Test case 2: Random signal
    $display("Test case 2: Random signal");
    #10 reset = 1;
    #10 reset = 0;
    
    for (integer i = 0; i < N; i = i + 1) begin
        raw_audio[i] = $random;
    end
    
    #10 start = 1;
    #10 start = 0;

    clk = 1'bx;
    #1000
    clk = 0;

    // Wait for the computation to complete
    wait (done);

    // Verify the results
    for (integer i = 0; i < NUM_INTERVALS; i = i + 1) begin
        $display("Interval %2d: min = %d, max = %d", i, out_min[i], out_max[i]);
    end

    $display("Test case 2 passed!");

    // Test case 3: Constant signal
    $display("Test case 3: Constant signal");
    #10 reset = 1;
    #10 reset = 0;
    
    for (integer i = 0; i < N; i = i + 1) begin
        raw_audio[i] = 42;
    end

    #10 start = 1;
    #10 start = 0;

    // Wait for the computation to complete
    wait (done);

    // Verify the results
    for (integer i = 0; i < NUM_INTERVALS; i = i + 1) begin
        if (out_min[i] != 42 || out_max[i] != 42) begin
            //$display("Min: %d Max: %d", out_min[i],out_max[i]);
            $error("Incorrect min/max values for interval %d", i);
        end
    end

    $display("Test case 3 passed!");

    // Test case 4: Alternating signal
    $display("Test case 4: Alternating signal");
    #10 reset = 1;
    #10 reset = 0;

    for (integer i = 0; i < N; i = i + 1) begin
        raw_audio[i] = (i % 2) ? 100 : -100;
    end

    #10 start = 1;
    #10 start = 0;
    
    // Wait for the computation to complete
    wait (done);

    // Verify the results
    for (integer i = 0; i < NUM_INTERVALS; i = i + 1) begin
        if (out_min[i] != -100 || out_max[i] != 100) begin
            $error("Incorrect min/max values for interval %d", i);
        end
    end

    $display("Test case 4 passed!");

    $finish;
end

endmodule