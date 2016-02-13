function myDecoder(codedFilename  , wavFilename)
% wavFilename = 'sample11.wav';
% codedFilename = 'bariemai.mat';
addpath ../task1/
addpath ../task2/
addpath ../task3/
addpath ../task4/
addpath ../task5/

load(codedFilename);

initstate = initStateDecoder();
% n = length(C);
xhat = 0;
counter =1;
% C = C;
C = b;

while counter < length(C) 
    sizeofwindow = bin2dec(C(counter : counter + 23));
    
    counter = counter + 24;
    t = C(counter : counter + sizeofwindow -1);
    counter = counter + sizeofwindow;
    
    [temp ,initstate]=decoder(t,initstate);
    xhat = [xhat temp];
end


size(xhat)
pause
y = xhat(2:end);
y = y';
Fs = 44100;
fd = 8200;
y = y';
y = changefs(y,fd, Fs);
%  y1 = y;
y = [y , 0 , 0 , 0, 0, 0, 0 , 0, 0, 0, 0, 0, 0];
y = reshape(y,length(y)/2,2);

 wavwrite(y, Fs, wavFilename)


