function myDecoder(codedFilename, wavFilename)
%  wavFilename = 'sample.wav';
% codedFilename = 'codedFilename.mat';


addpath ../task1/
addpath ../task2/
addpath ../task3/
addpath ../task4/
addpath ../task5/


%% Initialize everything
load(codedFilename);

initialState = initStateDecoder();

xHat = [];
counter = 1;

% Get the length of the binary word that represents the length of the
% original signal.
signalSizeWordLen = initialState.signalSizeWordLen;

windowSizeWordLen = initialState.windowSizeWordLen;
% Extract this parameter from the bitstream.
binarysize = b(1:signalSizeWordLen);

initialSignalSize = bin2dec(binarysize);
C = b(signalSizeWordLen + 1 : end);

%% Main decoding algorithm
while counter < length(C)
    currentWindowSize = bin2dec(C(counter:counter + windowSizeWordLen -1));
    counter = counter + windowSizeWordLen;
    
    t = C(counter : counter + currentWindowSize -1);
    counter = counter + currentWindowSize;
    [temp ,initialState] = decoder(t, initialState);
    xHat = [xHat temp];
end

L = initialState.L;
M = initialState.M;
% Upsample back to the original frequency.
% y = resample(y, 3, 1);

% Reshape to 2-D vector so as to restore the 2 channels.
outputSignal = reshape(xHat, length(xHat) / 2, 2);

% Upsample back to the original frequency.
y(:, 1) = resample(outputSignal(:, 1), L, M);
y(:, 2) = resample(outputSignal(:, 2), L, M);

% Append the wav file ending if necessary.
if isempty(strfind(wavFilename, '.wav'))
    wavFilename = [wavFilename '.wav'];
end
Fs = 44.1 * 10 ^ 3;
% Save as wav file
audiowrite(wavFilename, y, Fs);

end
