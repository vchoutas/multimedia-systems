function myDecoder(codedFilename  , wavFilename)
% wavFilename = 'sample.wav';
% codedFilename = 'codedFilename.mat';
addpath ../task1/
addpath ../task2/
addpath ../task3/
addpath ../task4/
addpath ../task5/
fileID = fopen(codedFilename,'r');


load(codedFilename);

initstate = initStateDecoder();
% n = length(C);
xhat = 0;
counter =1;
% C = C;
C=char(b{1});

while counter < length(C) 
    sizeofwindow = bin2dec(C(counter : counter + 23));
%     if sizeofwindow>5000
%         sizeofwindow
%         pause
%     end
    
    counter = counter + 24;
    b = C(counter : counter + sizeofwindow -1);
    counter = counter + sizeofwindow;
    
    [temp ,initstate]=decoder(b,initstate);
    xhat = [xhat temp];
    
end

y = xhat(2:end);
% y = y';
Fs = 44100;
wavwrite(y, Fs, wavFilename)
