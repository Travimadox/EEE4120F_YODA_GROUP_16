import wave
import numpy as np
import os

def wav_to_float_mono(wav_file):
    """
    Convert WAV file to 32-bit float raw data in mono format.
    
    Args:
        wav_file (str): Path to the WAV file.
        
    Returns:
        np.ndarray: Audio data as a numpy array of 32-bit float values (mono).
        int: Sample rate of the audio data.
    """
    with wave.open(wav_file, 'r') as wav:
        # Get WAV file parameters
        num_channels = wav.getnchannels()
        sample_width = wav.getsampwidth()
        sample_rate = wav.getframerate()
        num_frames = wav.getnframes()
        
        # Read WAV file data
        wav_data = wav.readframes(num_frames)
        
        # Convert bytes to a numpy array
        np_data = np.frombuffer(wav_data, dtype=np.int16)
        
        # Convert numpy array to 32-bit float
        float_data = np_data.astype(np.float32) / (2 ** 15)
        
        # Convert to mono if stereo
        if num_channels == 2:
            float_data = float_data.reshape(-1, 2)
            audio_data = float_data.mean(axis=1)
        else:
            audio_data = float_data
        
        return audio_data, sample_rate

def golden_standard(csv_file):
    """
    Compute the minimum and maximum values from the CSV file.
    
    Args:
        csv_file (str): Path to the CSV file.
        
    Returns:
        float: Minimum value in the CSV file.
        float: Maximum value in the CSV file.
    """
    audio_data = np.loadtxt(csv_file, delimiter=',')
    min_value = np.min(audio_data)
    max_value = np.max(audio_data)
    return min_value, max_value

# Set the directory containing the WAV files
wav_dir = 'Wavfiles'

# Loop over all WAV files in the directory
for wav_filename in os.listdir(wav_dir):
    if wav_filename.endswith('.wav'):
        wav_file = os.path.join(wav_dir, wav_filename)
        audio_data, sample_rate = wav_to_float_mono(wav_file)
        
        # Save audio data to a CSV file with the same name as the WAV file
        csv_filename = os.path.splitext(wav_filename)[0] + '.csv'
        csv_file = os.path.join(wav_dir, csv_filename)
        np.savetxt(csv_file, audio_data, delimiter=',', fmt='%.6f')
        print(f"Audio data saved to {csv_file}")
        
        # Compute the golden standard (minimum and maximum values)
        min_value, max_value = golden_standard(csv_file)
        
        # Write the minimum and maximum values to a text file
        txt_filename = os.path.splitext(wav_filename)[0] + '_basicminmax.txt'
        txt_file = os.path.join(wav_dir, txt_filename)
        with open(txt_file, 'w') as f:
            f.write(f"Minimum value in {csv_filename}: {min_value:.6f}\n")
            f.write(f"Maximum value in {csv_filename}: {max_value:.6f}\n")
        
        print(f"Global minimum and maximum values written to {txt_file}")
        print()  # Add an empty line for better readability