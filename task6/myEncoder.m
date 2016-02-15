function myEncoder(wavFilename, codedFilename)
% wavFilename = 'sample4.wav';
% codedFilename = 'bariemai.mat';

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
% fprintf(fileID, '%c' , dec2bin(initSize, signalSizeWordLen));

windowSize = initialState.windowSize;

% initialState.fileID = fileID;

% Calculate the required number of windows.
numWindows = floor(length(x)/ windowSize);

% initialState.fileId = fileID;

bitStream = [dec2bin(initSize, signalSizeWordLen)];

%% Call encoding function
for i = 0 : numWindows - 1
    if i ~= numWindows - 1;
        [t, initialState] = encoder(x(i * windowSize + 1 : (i + 1) * windowSize), initialState);
    else
        [t, initialState] = encoder(x((numWindows - 1) * windowSize + 1 : end), initialState);
    end    
    bitStream = [bitStream t];
end
% x = y(:, 2);
% for i = 0 : numWindows - 1
%     if i ~= numWindows - 1;
%         [t, initialState] = encoder(x(i * windowSize + 1 : (i + 1) * windowSize), initialState);
%     else
%         [t, initialState] = encoder(x((numWindows - 1) * windowSize + 1 : end), initialState);
%     end    
%     bitStream = [bitStream t];
% end

b = bitStream;
save(codedFilename, 'b');

end
