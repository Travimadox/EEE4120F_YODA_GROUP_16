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
// Test case: Hardcoded array from CSV file
initial begin
    clk = 0;
    reset = 1;
    start = 0;
    // Load the hardcoded array
    raw_audio[0] = 422212465065984;
    raw_audio[1] = 985162418487296;
    raw_audio[0] = 0;
    raw_audio[1] = 0;
    raw_audio[2] = 0;
    raw_audio[3] = 703687441776640;
    raw_audio[4] = 985162418487296;
    raw_audio[5] = 562949953421312;
    raw_audio[6] = 422212465065984;
    raw_audio[7] = 985162418487296;
    raw_audio[8] = 703687441776640;
    raw_audio[9] = 703687441776640;
    raw_audio[10] = 281474976710656;
    raw_audio[11] = 422212465065984;
    raw_audio[12] = -140737488355328;
    raw_audio[3] = 0;
    raw_audio[4] = 0;
    raw_audio[5] = 0;
    raw_audio[6] = 0;
    raw_audio[7] = 0;
    raw_audio[8] = 0;
    raw_audio[9] = 0;
    raw_audio[10] = 0;
    raw_audio[11] = 0;
    raw_audio[12] = 0;
    raw_audio[13] = 0;
    raw_audio[14] = 562949953421312;
    raw_audio[15] = 281474976710656;
    raw_audio[16] = -281474976710656;
    raw_audio[17] = -140737488355328;
    raw_audio[18] = 140737488355328;
    raw_audio[19] = 140737488355328;
    raw_audio[20] = 140737488355328;
    raw_audio[21] = -281474976710656;
    raw_audio[22] = -281474976710656;
    raw_audio[23] = 140737488355328;
    raw_audio[24] = 281474976710656;
    raw_audio[25] = -562949953421312;
    raw_audio[26] = -562949953421312;
    raw_audio[14] = 0;
    raw_audio[15] = 0;
    raw_audio[16] = 0;
    raw_audio[17] = 0;
    raw_audio[18] = 0;
    raw_audio[19] = 0;
    raw_audio[20] = 0;
    raw_audio[21] = 0;
    raw_audio[22] = 0;
    raw_audio[23] = 0;
    raw_audio[24] = 0;
    raw_audio[25] = 0;
    raw_audio[26] = 0;
    raw_audio[27] = 0;
    raw_audio[28] = 0;
    raw_audio[29] = 0;
    raw_audio[30] = 0;
    raw_audio[31] = 0;
    raw_audio[32] = 0;
    raw_audio[33] = 0;
    raw_audio[34] = 0;
    raw_audio[35] = 0;
    raw_audio[36] = 0;
    raw_audio[37] = 0;
    raw_audio[38] = 0;
    raw_audio[39] = 0;
    raw_audio[40] = 0;
    raw_audio[41] = 0;
    raw_audio[42] = 0;
    raw_audio[43] = 0;
    raw_audio[44] = 0;
    raw_audio[45] = 0;
    raw_audio[46] = 0;
    raw_audio[47] = 0;
    raw_audio[48] = 0;
    raw_audio[49] = 0;
    raw_audio[50] = 0;
    raw_audio[51] = 0;
    raw_audio[52] = 0;
    raw_audio[53] = 0;
    raw_audio[54] = 0;
    raw_audio[55] = 0;
    raw_audio[56] = 0;
    raw_audio[57] = 0;
    raw_audio[58] = 0;
    raw_audio[59] = 0;
    raw_audio[60] = 0;
    raw_audio[61] = 0;
    raw_audio[62] = 0;
    raw_audio[63] = 0;
    raw_audio[64] = 0;
    raw_audio[65] = 0;
    raw_audio[66] = 0;
    raw_audio[67] = 0;
    raw_audio[68] = 0;
    raw_audio[69] = 0;
    raw_audio[70] = 0;
    raw_audio[71] = 0;
    raw_audio[72] = 0;
    raw_audio[73] = 0;
    raw_audio[74] = 0;
    raw_audio[75] = 0;
    raw_audio[76] = 0;
    raw_audio[77] = 0;
    raw_audio[78] = 0;
    raw_audio[79] = 0;
    raw_audio[80] = 0;
    raw_audio[81] = 0;
    raw_audio[82] = 0;
    raw_audio[83] = 0;
    raw_audio[84] = 0;
    raw_audio[85] = 0;
    raw_audio[86] = 0;
    raw_audio[87] = 0;
    raw_audio[88] = 0;
    raw_audio[89] = 0;
    raw_audio[90] = 0;
    raw_audio[91] = 0;
    raw_audio[92] = 0;
    raw_audio[93] = 0;
    raw_audio[94] = 0;
    raw_audio[95] = 0;
    raw_audio[96] = 0;
    raw_audio[97] = 0;
    raw_audio[98] = 0;
    raw_audio[99] = 0;
    #10 reset = 0;
    #10 start = 1;
    #10 start = 0;
    // Wait for the computation to complete
    wait (d);
    // Print the results
    $display("Maximum: %d, Minimum: %d", out_max, out_min);
end
endmodule
