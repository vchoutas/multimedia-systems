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
sizeoflength = 32;
binarysize = b(1 : sizeoflength);
sizeofinitX = bin2dec(binarysize);

C = b(sizeoflength + 1 : end);


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


ytemp = xhat(2:end);

%% Upsample back in original frequency
% ytemp = resample(ytemp, 4, 1);
Fs = 44100;
fd = 8000;
% ytemp = ytemp';
ytemp = changefs(ytemp, fd, Fs, 'spline');

%% fix in order to have the same size

y = zeros(sizeofinitX, 1);
if sizeofinitX >= length(ytemp)
    y(1:length(ytemp)) = ytemp;
else
    y = ytemp(1:length(y));
end

%% Reshape in 2-D vector
y = reshape(y,length(y)/2,2);

%% Save as wav file
Fs = 44100;
 wavwrite(y, Fs, wavFilename)


