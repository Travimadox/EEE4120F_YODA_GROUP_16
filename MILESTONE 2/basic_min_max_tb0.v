`timescale 1ns / 1ps

module audio_min_max_tb;

localparam N = 100; // Number of samples

reg reset, start, clk;
reg signed [31:0] raw_audio [N-1:0];
wire d;
wire signed [31:0] out_max, out_min;

// Instantiate audio_min_max
audio_min_max aud_minmax (
    .reset(reset),
    .start(start),
    .clk(clk),
    .raw_audio(raw_audio),
    .d(d),
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
//Remeber to comment out the test cases that you are not testing
initial begin
    clk = 0;
    reset = 1;
    start = 0;

    // Test case 1: Ramp signal
    $display("Test case 1 : Ramp signal");
    for (integer i = 0; i < N; i = i + 1) begin
        raw_audio[i] = i;
    end

    #10 reset = 0;
    #10 start = 1;
    #10 start = 0;

    // Wait for the computation to complete
    wait (d);
    $display("Test case 1: Ramp signal, min = %d, max = %d", out_min, out_max);

    // Verify the results
    if (out_min != 0 || out_max != N - 1) begin
        $error("Incorrect min/max values for ramp signal");
    end else begin
        $display("Test case 1 passed!");
    end
    $display("-------------------------------");

    // Test case 2: Random signal
    $display("Test case 2 : Random Signal");

    #10 reset = 1;
    #10 reset = 0;
    
    for (integer i = 0; i < N; i = i + 1) begin
        raw_audio[i] = $random;
    end
    
    #10 start = 1;
    #10 start = 0;

    // Wait for the computation to complete
    wait (d);
    // Verify the results
    $display("Test case 2: Random signal, min = %d, max = %d", out_min, out_max);
    $display("-------------------------------");

    // Test case 3: Constant signal
    $display("Test case 3 : Constant Signal");
    #10 reset = 1;
    #10 reset = 0;

    for (integer i = 0; i < N; i = i + 1) begin
        raw_audio[i] = 42;
    end

    #10 start = 1;
    #10 start = 0;

    // Wait for the computation to complete
    wait (d);
    $display("Test case 3: Constant signal, min = %d, max = %d", out_min, out_max);

    // Verify the results
    if (out_min != 42 || out_max != 42) begin
        $error("Incorrect min/max values for constant signal");
    end else begin
        $display("Test case 3 passed!");
    end
    $display("-------------------------------");


  	   // Test case 4: Alternating signal
    $display("Test case 4 : Alternating Signal");
    #10 reset = 1;
    #10 reset = 0;

    for (integer i = 0; i < N; i = i + 1) begin
        raw_audio[i] = (i % 2) ? 100 : -100;
    end

    #10 start = 1;
    #10 start = 0;

    // Wait for the computation to complete
    wait (d);
    
    $display("Test case 4: Alternating signal, min = %d, max = %d", out_min, out_max);

    // Verify the results
    if (out_min != -100 || out_max != 100) begin
        $error("Incorrect min/max values for alternating signal");
    end else begin
        $display("Test case 4 passed!");
    end
    $display("-------------------------------");


    $finish;
end
endmodule