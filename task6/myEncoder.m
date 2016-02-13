function myEncoder(wavFilename, codedFilename)
% wavFilename = 'sample1.wav';
% codedFilename = 'sample2.mat';
%% Addpaths in order to use functions from previous tasks
addpath ../task1/
addpath ../task2/
addpath ../task3/
addpath ../task4/
addpath ../task5/

%% Open a file to write
fileID = fopen('temp.mat' ,'w');

%% Load the file to be encoded
[y, fs] = wavread(wavFilename);
% sound(y,fs);
% length(y)
% pause
%% Reshape y in 1-D vector
% y = reshape(y,2*size(y,1), 1);
% sound(y,fs);

% %% Change in the desired frequency
% y = y';
% fd = 44100; % desired frequency
% x = changefs(y, fs, fd);
x = y;
%% Find number of windows that will be used
% s
% length(x)
n=floor(length(x)/500);
%Number of elements in each window
NofEl = floor(length(x)/n);

initstate = initStateEncoder();

initstate.fileId = fileID;

for i = 0 : n-1
    if i ~= n-1;
        [t, initstate] = encoder(x(i * NofEl + 1 : (i + 1) * NofEl), initstate);
        fprintf(fileID,'%c',t);
    else
        [t, initstate] = encoder(x((n - 1) * NofEl + 1 : end), initstate);
        fprintf(fileID,'%c',t);
    end
end
fclose(fileID);
fileID = fopen('temp.mat','r');


b = textscan(fileID, '%s', '\n');

save(codedFilename, 'b');


