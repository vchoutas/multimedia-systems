function myDecoder(codedFilename  , wavFilename)
% wavFilename = 'sample11.wav';
% codedFilename = 'bariemai.mat';
addpath ../task1/
addpath ../task2/
addpath ../task3/
addpath ../task4/
addpath ../task5/


%% Initialize everything
load(codedFilename);

initstate = initStateDecoder();

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
    [temp ,initstate]=decoder(t,initstate);
    xhat = [xhat temp];
end


y = xhat(2:end);

%% Upsample back in original frequency
y = resample(y, 3, 1);

%% Reshape in 2-D vector
y = reshape(y,length(y)/2,2);

%% Save as wav file
Fs = 44100;
 wavwrite(y, Fs, wavFilename)


