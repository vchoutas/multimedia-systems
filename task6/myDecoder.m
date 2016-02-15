function myDecoder(codedFilename, wavFilename)
%MYDECODER Takes as input the name of an encoded audio file, reads the
%bitstream and decodes it to produce an estimate of the original signal
% codedFileName The name of the .mat file that contains the encoded audio
% file.
% wavFileName The desired output name for the decoded version of the file.

% Add the necessary paths in order to access the functions used to decoded
% the encoded signal.
addpath ../task1/
addpath ../task2/
addpath ../task3/
addpath ../task4/
addpath ../task5/


% Load the coded sequence into the workspace.
load(codedFilename);

% Get the starting state for the decoder.
initialState = initStateDecoder();

% Initialize the decoded signal as an empty array.
xHat = [];

% Create a variable that will be used to calculate our current position in
% the bitstream.
counter = 1;

% Get the length of the binary word that represents the length of the
% original signal.
signalSizeWordLen = initialState.signalSizeWordLen;

% Get the size of the binary word used to store the size of each window.
windowSizeWordLen = initialState.windowSizeWordLen;

% Extract the size of the original signal from the bitstream.
binarysize = b(1:signalSizeWordLen);
initialSignalSize = bin2dec(binarysize);

% Store the rest of the signal in a separate variable.
bitStream = b(signalSizeWordLen + 1 : end);

%% Main decoding algorithm
while counter < length(bitStream)
    % Extract the size of the current window.
    currentWindowSize = bin2dec(bitStream(counter:counter + windowSizeWordLen -1));
    % Update the counter so that it now points to the start of the encoded
    % signal.
    counter = counter + windowSizeWordLen;
    
    % Extract the next window from the signal and update the counter.
    t = bitStream(counter : counter + currentWindowSize -1);
    counter = counter + currentWindowSize;
    % Decode the current window.
    [temp ,initialState] = decoder(t, initialState);
    
    % Append the newly decoded window to the decoded signal variable.
    xHat = [xHat; temp];
end

% Get the resampling paramaters from the state of the decoder.
L = initialState.L;
M = initialState.M;

% Reshape to 2-D vector so as to restore the 2 channels.
outputSignal = reshape(xHat(1:2*floor(length(xHat) / 2)), ...
    floor(length(xHat) / 2), 2);

% Upsample back to the original frequency.
tmp(:, 1) = resample(outputSignal(:, 1), L, M);
tmp(:, 2) = resample(outputSignal(:, 2), L, M);

% Get the final decoded version from the resampled 
y(:, 1) = tmp(1:initialSignalSize, 1);
y(:, 2) = tmp(1:initialSignalSize, 2);

% Append the wav file ending if necessary.
if isempty(strfind(wavFilename, '.wav'))
    wavFilename = [wavFilename '.wav'];
end

Fs = 44.1 * 10 ^ 3;
% Save as wav file
audiowrite(wavFilename, y, Fs);

end
