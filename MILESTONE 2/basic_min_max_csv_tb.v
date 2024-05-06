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
    raw_audio[27] = 0;
    raw_audio[28] = -281474976710656;
    raw_audio[29] = -422212465065984;
    raw_audio[30] = -281474976710656;
    raw_audio[31] = -140737488355328;
    raw_audio[32] = -422212465065984;
    raw_audio[33] = -844424930131968;
    raw_audio[34] = -985162418487296;
    raw_audio[35] = -703687441776640;
    raw_audio[36] = -422212465065984;
    raw_audio[37] = -422212465065984;
    raw_audio[38] = -703687441776640;
    raw_audio[39] = -562949953421312;
    raw_audio[40] = -1125899906842624;
    raw_audio[41] = -703687441776640;
    raw_audio[42] = -1266637395197952;
    raw_audio[43] = -1125899906842624;
    raw_audio[44] = -1125899906842624;
    raw_audio[45] = -844424930131968;
    raw_audio[46] = -1266637395197952;
    raw_audio[47] = -1548112371908608;
    raw_audio[48] = -1829587348619264;
    raw_audio[49] = -1548112371908608;
    raw_audio[50] = -1688849860263936;
    raw_audio[51] = -1548112371908608;
    raw_audio[52] = -1688849860263936;
    raw_audio[53] = -1688849860263936;
    raw_audio[54] = -1407374883553280;
    raw_audio[55] = -1548112371908608;
    raw_audio[56] = -1829587348619264;
    raw_audio[57] = -1970324836974592;
    raw_audio[58] = -1266637395197952;
    raw_audio[59] = -1829587348619264;
    raw_audio[60] = -1266637395197952;
    raw_audio[61] = -1266637395197952;
    raw_audio[62] = -1688849860263936;
    raw_audio[63] = -2251799813685248;
    raw_audio[64] = -1970324836974592;
    raw_audio[65] = -2674012278751232;
    raw_audio[66] = -2111062325329920;
    raw_audio[67] = -2251799813685248;
    raw_audio[68] = -1829587348619264;
    raw_audio[69] = -2251799813685248;
    raw_audio[70] = -2111062325329920;
    raw_audio[71] = -2251799813685248;
    raw_audio[72] = -2251799813685248;
    raw_audio[73] = -1970324836974592;
    raw_audio[74] = -1970324836974592;
    raw_audio[75] = -2392537302040576;
    raw_audio[76] = -2533274790395904;
    raw_audio[77] = -1970324836974592;
    raw_audio[78] = -2111062325329920;
    raw_audio[79] = -2955487255461888;
    raw_audio[80] = -2674012278751232;
    raw_audio[81] = -2111062325329920;
    raw_audio[82] = -2674012278751232;
    raw_audio[83] = -2533274790395904;
    raw_audio[84] = -2814749767106560;
    raw_audio[85] = -2392537302040576;
    raw_audio[86] = -2674012278751232;
    raw_audio[87] = -2674012278751232;
    raw_audio[88] = -3096224743817216;
    raw_audio[89] = -2674012278751232;
    raw_audio[90] = -2674012278751232;
    raw_audio[91] = -2955487255461888;
    raw_audio[92] = -3096224743817216;
    raw_audio[93] = -3236962232172544;
    raw_audio[94] = -2814749767106560;
    raw_audio[95] = -3236962232172544;
    raw_audio[96] = -3096224743817216;
    raw_audio[97] = -3799912185593856;
    raw_audio[98] = -2955487255461888;
    raw_audio[99] = -3096224743817216;
    #10 reset = 0;
    #10 start = 1;
    #10 start = 0;
    // Wait for the computation to complete
    wait (d);
    // Print the results
    $display("Maximum: %d, Minimum: %d", out_max, out_min);
end
endmodule
