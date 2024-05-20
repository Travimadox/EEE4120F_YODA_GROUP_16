`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2024 11:36:57 AM
// Design Name: 
// Module Name: basic_minmax_tb
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


module basic_minmax_tb();
parameter WIDTH = 32, NO_OF_SAMPLES = 66150;

reg clk;

// set connection ports for the basic filter
reg reset, start, done;
reg signed [WIDTH-1:0] audio_in [NO_OF_SAMPLES-1:0];
reg signed [WIDTH-1:0] min, max;

// instantiate basic_minmax
basic_minmax #(.NO_OF_SAMPLES(NO_OF_SAMPLES), .WIDTH(WIDTH)) b_minmax 
(
    .clk(clk),
    .start(start),
    .reset(reset),
    .audio_in(audio_in),
    .done(done),
    .min(min),
    .max(max)
);

// set connection port for the waw_read module
reg start_w, reset_w, done_w, error;
reg signed [WIDTH-1:0] audio_out [NO_OF_SAMPLES-1:0];
reg signed [WIDTH-1:0] wave;

// instantiate wav_read
wav_read wav_read_inst (
    .clk(clk),
    .start(start_w),
    .reset(reset_w),
    .done(done_w),
    .audio_out(audio_out),
    .audio_wave(wave),
    .error(error)
);


// Clock generation
always #5 clk = ~clk;

initial begin
    // initialise clock
    clk = 0;
    // reset b_minmax & wav_read_inst
    reset = 1;
    reset_w = 1;
    start = 0;
    start_w =0;

    #10 reset_w = 0; 
    

    // start wav_read_inst first
    #10 start_w = 1; 
    #20 start_w = 0;
    if(error) begin
        //$display("Using default audio data");
        $display("basic_minmax_tb: An error was encountered, aborting tests...");
        $finish;
    end else begin
        wait(done_w); // wait for wav_read_inst to finish getting the data
        audio_in = audio_out;
    end
    // start baisc_minmax when wav_read_inst is done
    #10 reset = 0;
    #10 start = 1;   
    #10 start = 0;   
    // Wait for the computation to complete
    wait (done);
    // Print the results
    #10
    $display("basic_minmax_tb: Min: %1d, Max: %1d", min, max);
    $finish;

end

endmodule
