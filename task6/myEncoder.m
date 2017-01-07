function myEncoder(wavFilename, codedFilename)
%ENCODER Takes as input the name of an audio file, reads it and encodes it 
% to produce a compressed version of the original.
%wavFileName The name of the input audio file.
%codedFileName The name of the .mat file that will contain the encoded
% bistream.


% Addpaths in order to use functions from previous tasks
addpath ../task1/
addpath ../task2/
addpath ../task3/
addpath ../task4/
addpath ../task5/

% Append the wav file ending if necessary.
if isempty(strfind(wavFilename, '.wav'))
    wavFilename = [wavFilename '.wav'];
end

% Load the file to be encoded
[currentAudioSample, fs] = audioread(wavFilename);

% Find number of windows that will be used
initialState = initStateEncoder();

% Get the resampling parameters.
L = initialState.L;
M = initialState.M;
% Change in the desired frequency

y(:, 1) = resample(currentAudioSample(:, 1), L, M);
y(:, 2) = resample(currentAudioSample(:, 2), L, M);
% Reshape y in 1-D vector
x = reshape(y, 2 * size(y, 1), 1);

% Initial size
initSize = length(currentAudioSample(:, 1));
signalSizeWordLen = initialState.signalSizeWordLen;

% Get the number of windows that will be used to encode the signal
windowSize = initialState.windowSize;

% Calculate the required number of windows.
numWindows = floor(length(x)/ windowSize);

% Store the size of the orignal signal in the bitstream.
bitStream = [dec2bin(initSize, signalSizeWordLen)];

%% Call encoding function on every window of the signal.
for i = 0 : numWindows - 1
    if i ~= numWindows - 1;
        [t, initialState] = encoder(x(i * windowSize + 1 : (i + 1) * windowSize), initialState);
    else
        [t, initialState] = encoder(x((numWindows - 1) * windowSize + 1 : end), initialState);
    end    
    bitStream = [bitStream t];
end

% Store the bitstream in provided file.
b = bitStream;
save(codedFilename, 'b');

end
