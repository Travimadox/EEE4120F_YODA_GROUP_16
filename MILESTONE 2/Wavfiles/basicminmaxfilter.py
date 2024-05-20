import wave
import numpy as np
import os
import time

def read_wav_file(filename):
    # Open the WAV file
    with wave.open(filename, 'rb') as wav_file:
        # Get the number of frames
        num_frames = wav_file.getnframes()
        # Read frames
        frames = wav_file.readframes(num_frames)
        # Get the sample width (number of bytes per sample)
        sample_width = wav_file.getsampwidth()
        # Get the number of channels
        num_channels = wav_file.getnchannels()
        # Get the sample rate
        sample_rate = wav_file.getframerate()
        # Determine the format for numpy
        dtype_map = {1: np.uint8, 2: np.int16, 4: np.int32}
        if sample_width not in dtype_map:
            raise ValueError(f"Unsupported sample width: {sample_width}")
        dtype = dtype_map[sample_width]
        # Convert frames to numpy array
        audio_data = np.frombuffer(frames, dtype=dtype)
        # If stereo, reshape array to separate channels
        if num_channels > 1:
            audio_data = np.reshape(audio_data, (-1, num_channels))
        return audio_data, sample_rate, num_channels

def calculate_min_max_amplitude(audio_data):
    start_time = time.perf_counter_ns()
    min_amplitude = np.min(audio_data)
    max_amplitude = np.max(audio_data)
    end_time = time.perf_counter_ns()
    elapsed_time_ns = end_time - start_time

    elapsed_time_s = elapsed_time_ns / 1_000_000_000
    print(f"Elapsed time: {elapsed_time_ns} nanoseconds")
    print(f"Elapsed time: {elapsed_time_s} seconds")
    #print(f"Elapsed time: {elapsed_time} seconds")
    return min_amplitude, max_amplitude

def main(filename):
    # Get the directory of the current script
    script_dir = os.path.dirname(os.path.realpath(__file__))
    # Construct the full path to the file
    file_path = os.path.join(script_dir, filename)
    audio_data, sample_rate, num_channels = read_wav_file(file_path)
    min_amplitude, max_amplitude = calculate_min_max_amplitude(audio_data)
    print(f"Minimum amplitude: {min_amplitude}")
    print(f"Maximum amplitude: {max_amplitude}")

if __name__ == "__main__":
    filename = "StarWars3.wav"  # Change this to your actual file name
    main(filename)
