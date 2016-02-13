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

windowSize = initialState.windowSize;

xhat = 0;
counter =1;
C = b;

%% Main decoding algorithm
while counter < length(C)
    size_of_bin_stream_length = 24;
    sizeofwindow = bin2dec(C(counter : counter + size_of_bin_stream_length -1));
    counter = counter + size_of_bin_stream_length;
    t = C(counter : counter + sizeofwindow -1);
    counter = counter + sizeofwindow;
    [temp ,initialState]=decoder(t,initialState);
    xhat = [xhat temp];
end
y = xhat(2:end);

L = initialState.L;
M = initialState.M;
% Upsample back to the original frequency.
% y = resample(y, 3, 1);

% Upsample back to the original frequency.
y(:, 1) = resample(y(:, 1), L, M);
y(:, 2) = resample(y(:, 2), L, M);

% Reshape to 2-D vector so as to restore the 2 channels.
y = reshape(y, length(y) / 2, 2);

% Save as wav file
Fs = 44100;

% Append the wav file ending if necessary.
if isempty(findstr(wavFilename, '.wav'))
    wavFilename = [wavFilename '.wav'];
end

audiowrite(wavFilename, y, Fs);

end
