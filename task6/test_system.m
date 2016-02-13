clear all
close all

sampleName = 'sample4';

% Append the wav file ending if necessary.
if isempty(findstr(sampleName, '.wav'))
    wavFilename = [sampleName '.wav'];
else
    wavFilename = sampleName;
end

[y, fs] = audioread(wavFilename);

codedFileName = ['coded' sampleName];

myEncoder(sampleName, codedFileName);
fprintf('Finished Encoding!\n')

myDecoder(codedFileName, codedFileName);
fprintf('Finished Decoding!\n')


% Append the wav file ending if necessary.
if isempty(findstr(codedFileName, '.wav'))
    codedWavFilename = [codedFileName '.wav'];
else
    codedWavFilename = codedFileName;
end

[compressedY, fs] = audioread(codedWavFilename);

e = (y - compressedY).^2;
totalE = sum(e) / size(e, 1);

load([codedFileName '.mat'])

fprintf('Length of encoded sequence = %d \n', length(b))
fprintf('MSE channel 1, 2 = %f , %f \n', totalE(1), totalE(2));
