`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TEAM 14
// Engineer: TEAM 14
// 
// Create Date: 05/19/2024 03:44:00 PM
// Design Name: Interval Min-Max Filter Testbench
// Module Name: interval_minmax_tb
// Project Name: SPM
// Target Devices: Nexys A7 FPGA
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


module interval_minmax_tb();

reg clk;


// set connection ports for the interval filter
parameter NO_OF_SAMPLES = 66150,  
    WIDTH = 32, 
    INTERVAL_WIDTH = 16, 
    INTERVAL_LEN = 10, 
    NO_OF_INTERVALS = NO_OF_SAMPLES/INTERVAL_LEN;

reg start, reset, done;

reg signed [WIDTH-1:0] audio_in [NO_OF_SAMPLES-1:0];
reg [INTERVAL_WIDTH-1:0] interval_len = INTERVAL_LEN;

reg signed [WIDTH-1:0] min [NO_OF_INTERVALS:0];
reg signed [WIDTH-1:0] max [NO_OF_INTERVALS:0];

reg signed [WIDTH-1:0] filtered_wave;

// instantiate interval_minmax
interval_minmax #
(
    .NO_OF_SAMPLES(NO_OF_SAMPLES), 
    .WIDTH(WIDTH), 
    .INTERVAL_WIDTH(INTERVAL_WIDTH), 
    .INTERVAL_LEN(INTERVAL_LEN), 
    .NO_OF_INTERVALS(NO_OF_INTERVALS)
)
int_minmax
(
    .clk(clk),
    .start(start),
    .reset(reset),
    .audio_in(audio_in),
    .interval_len(interval_len),
    .done(done),
    .min(min),
    .max(max),
    .filtered_wave(filtered_wave) 
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

    // reset wav_read_inst
    reset_w = 1;
    start_w =0;
    #10 reset_w = 0; 
    

    // start wav_read_inst first
    #10 start_w = 1; 
    #10 start_w = 0;

    if(error) begin
        //$display("Using default audio data");
        $display("basic_minmax_tb: An error was encountered, aborting tests...");
        $finish;
    end
    wait(done_w); // wait for wav_read_inst to finish getting the data
    audio_in = audio_out;
    
    
    // start baisc_minmax when wav_read_inst is done
    //if(done_w) begin
    start = 0;
    reset = 1;
    #10 reset = 0;
    
    $display("Starting int_minmax");
    #10 start = 1;  
    #10 start = 0;   
    
    // Wait for the computation to complete
    wait(done);
    
    #10
    // Print the results
    // for (int i = 0; i<NO_OF_INTERVALS; i=i+1) begin
    //     $display("%1d. Min: %1d, Max: %1d", i, min[i], max[i]);
    // end
    #10
    $finish; 
    //end   
end

endmodule
