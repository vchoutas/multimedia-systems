function myEncoder(wavFilename, codedFilename)
% wavFilename = 'sample4.wav';
% codedFilename = 'bariemai.mat';

% Addpaths in order to use functions from previous tasks
addpath ../task1/
addpath ../task2/
addpath ../task3/
addpath ../task4/
addpath ../task5/

% Open a file to write
fileID = fopen('temp.mat', 'w');
if fileID < 0
    fprintf('Could not open temporary write buffer \n');
    return
end

% Append the wav file ending if necessary.
if isempty(findstr(wavFilename, '.wav'))
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

windowSize = initialState.windowSize;
initialState.fileID = fileID;

% Calculate the required number of windows.
numWindows = floor(length(x)/ windowSize)


initialState.fileId = fileID;
%% Call encoding function
for i = 0 : numWindows - 1
    if i ~= numWindows - 1;
        [t, initialState] = encoder(x(i * windowSize + 1 : (i + 1) * windowSize), initialState);
        fprintf(fileID,'%c', t);
    else
        [t, initialState] = encoder(x((numWindows - 1) * windowSize + 1 : end), initialState);
        fprintf(fileID,'%c', t);
    end
end

fclose(fileID);
fileID = fopen('temp.mat', 'r');

b = textscan(fileID, '%s', 'Delimiter', '\n');

b = char(b{1});
save(codedFilename, 'b');

end
