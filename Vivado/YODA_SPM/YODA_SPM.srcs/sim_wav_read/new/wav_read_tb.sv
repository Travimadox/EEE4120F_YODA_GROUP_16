`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TEAM 16
// Engineer: TEAM 16
// 
// Create Date: 05/18/2024 06:28:12 PM
// Design Name: Wav Read Testbench
// Module Name: wav_read_tb
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


module wav_read_tb();

parameter WIDTH = 32, NO_OF_SAMPLES = 66150;
parameter string FILEPATH = "StarWars3.wav";

reg clk, start, reset, done, error;
reg signed [WIDTH-1:0] wave, audio_out [NO_OF_SAMPLES-1:0];

wav_read #(.FILEPATH(FILEPATH), .NO_OF_SAMPLES(NO_OF_SAMPLES), .WIDTH(WIDTH)) wav_read_inst 
(
    .clk(clk),
    .start(start),
    .reset(reset),
    .done(done),
    .audio_out(audio_out),
    .audio_wave(wave),
    .error(error)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    start = 0;

    #10 reset = 0;
    #10 start = 1;
    #10 start = 0;

    wait (done);
end

endmodule
