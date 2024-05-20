import wave
import numpy as np
import os

def read_wav_file(filename):
    # Open the WAV file
    with wave.open(filename, 'rb') as wav_file:
        # Get parameters
        num_frames = wav_file.getnframes()
        sample_width = wav_file.getsampwidth()
        num_channels = wav_file.getnchannels()
        sample_rate = wav_file.getframerate()

        # Read frames
        frames = wav_file.readframes(num_frames)
        
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

def calculate_min_max_intervals(audio_data, sample_rate, num_channels, interval_seconds):
    interval_samples = interval_seconds * sample_rate
    total_samples = audio_data.shape[0] // num_channels
    
    min_max_values = []
    
    for start in range(0, total_samples, interval_samples):
        end = min(start + interval_samples, total_samples)
        
        if num_channels > 1:
            chunk = audio_data[start:end, :]
            min_amplitude = np.min(chunk)
            max_amplitude = np.max(chunk)
        else:
            chunk = audio_data[start:end]
            min_amplitude = np.min(chunk)
            max_amplitude = np.max(chunk)
        
        min_max_values.append((min_amplitude, max_amplitude))
    
    return min_max_values

def main(filename, interval_seconds):
    # Get the directory of the current script
    script_dir = os.path.dirname(os.path.realpath(__file__))
    # Construct the full path to the file
    file_path = os.path.join(script_dir, filename)
    audio_data, sample_rate, num_channels = read_wav_file(file_path)
    min_max_values = calculate_min_max_intervals(audio_data, sample_rate, num_channels, interval_seconds)
    
    for i, (min_val, max_val) in enumerate(min_max_values):
        interval_start_time = i * interval_seconds
        print(f"Interval {interval_start_time}s - {interval_start_time + interval_seconds}s:")
        print(f"    Min amplitude: {min_val}")
        print(f"    Max amplitude: {max_val}")

if __name__ == "__main__":
    filename = "StarWars3.wav"  # Change this to your actual file name
    interval_seconds = 10  # Change this to your desired interval in seconds
    main(filename, interval_seconds)
