import os
import wave
import numpy as np

def wav_to_float(wav_file, num_samples):
    """
    Convert WAV file to 32-bit float raw data and truncate it to the given number of samples.
    
    Args:
        wav_file (str): Path to the WAV file.
        num_samples (int): Number of samples to keep.
        
    Returns:
        np.ndarray: Truncated audio data as a numpy array of 32-bit float values.
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
        
        # Truncate the data to the given number of samples
        truncated_data = float_data[:num_samples]
        
        # Reshape the array based on the number of channels
        if num_channels == 1:
            audio_data = truncated_data
        else:
            audio_data = truncated_data.reshape(-1, num_channels)
        
        return audio_data, sample_rate

def convert_wav_files(input_dir, output_dir, num_samples):
    """
    Convert all WAV files in the given directory and save the truncated versions in the output directory.
    
    Args:
        input_dir (str): Path to the input directory.
        output_dir (str): Path to the output directory.
        num_samples (int): Number of samples to keep.
    """
    # Create the output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Go through all files in the input directory
    for filename in os.listdir(input_dir):
        # Check if the file is a WAV file
        if filename.endswith('.wav'):
            # Convert the WAV file to 32-bit float raw data
            audio_data, sample_rate = wav_to_float(os.path.join(input_dir, filename), num_samples)
            
            # Save the truncated audio data to the output directory
            np.savetxt(os.path.join(output_dir, filename.replace('.wav', '.csv')), audio_data)

# Example usage
num_samples = 100  # Number of samples to keep
convert_wav_files('Wavfiles', 'convertedwav', num_samples)