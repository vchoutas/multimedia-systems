clear all
close all

sampleName = 'sample4';

[y, fs] = wavread(sampleName);

codedFileName = ['coded' sampleName];

myEncoder(sampleName, codedFileName);
fprintf('Finished Encoding!\n')

myDecoder(codedFileName, codedFileName);
fprintf('Finished Decoding!\n')

[compressedY, fs] = wavread(codedFileName);

e = (y - compressedY).^2;
totalE = sum(e) / size(e, 1);

fprintf('MSE channel 1, 2 = %f , %f \n', totalE(1), totalE(2));
