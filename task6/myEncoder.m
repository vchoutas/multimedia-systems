function myEncoder(wavFilename, codedFilename)
% wavFilename = 'sample4.wav';
% codedFilename = 'bariemai.mat';
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

%% Reshape y in 1-D vector
y = reshape(y,2*size(y,1), 1);

%% Initial size
initsize = length(y);
fprintf(fileID, '%c' , dec2bin(initsize, 32));

%% Change in the desired frequency
% x = resample(y, 1, 4);
y = y';
fd = 21000;
x = changefs(y, fs, fd, 'spline');

%% Find number of windows that will be used
n=floor(length(x)/2000);
%Number of elements in each window
NofEl = floor(length(x)/n);

initstate = initStateEncoder();

initstate.fileId = fileID;
%% Call encoding function
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

%% something in order to work
b = textscan(fileID, '%s', '\n');
b = b{1};
b = char(b);
save(codedFilename, 'b');


