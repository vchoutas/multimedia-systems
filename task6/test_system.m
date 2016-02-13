clear all
close all

sampleName = 'sample1';

[y, fs] = wavread(sampleName);

codedFileName = ['coded' sampleName];

myEncoder(sampleName, codedFileName);
fprintf('Finished Encoding!\n')

myDecoder(codedFileName, codedFileName);
fprintf('Finished Decoding!\n')


