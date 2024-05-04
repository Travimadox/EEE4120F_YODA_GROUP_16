// set simulation time:
`timescale 1ns / 1ps

module aud_min_max_tb;
  
	localparam N = 100; //no of samples
  
    reg reset, start, clk;
    reg [31:0] raw_audio [N-1:0];
    reg [31:0] out_max, out_min;

    // Instatiate audio_min_max
    audio_min_max aud_minmax(
        .reset(reset),
        .start(start),
        .clk(clk),
        .raw_audio(raw_audio),
        .d(d),
        .out_max(out_max),
        .out_min(out_min)
    );
  
  	

    // Clock generation
    always #10 clk = ~clk;

    initial begin
      $readmemh("random_hex.txt", raw_audio,0,N-1);
        $display("Done reading");
        // TODO 1 
        // Create a module to convert .wav to raw data [32-bit float]
        // Input audio file PATH,... Output: raw _audio_samples[N:0]
    end

    initial begin
        reset = 1;
        start = 0;
        clk = 0;

        #100

        reset = 0;

        #5
        $display("Starting... audio_min_max");

        start = 1;
        #10
        start = 0;

        wait(d); //wait for the done signal
        #5
        $display("Audio Min: %h Max: %h",out_min, out_max);
        #5
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars; 
    end
endmodule