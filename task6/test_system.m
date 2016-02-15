clear all
close all

%% A simple script used to test our implementation.

% The current sample that will be used.
numSamples = 4;
sampleNames = {};
for i = 1:numSamples
    sampleNames{i} = ['sample' num2str(i)];
end

userAns = input(['Do you want to hear the results of the\n encoding vs' ...
    ' the original signal?[Y/N]'], 's');
if strcmpi(userAns, 'Y') || strcmpi(userAns, 'yes')
    playSound = true;
else
    playSound = false;
end

for i = 1 : numSamples
    % Append the wav file ending if necessary.
    if isempty(strfind(sampleNames{i}, '.wav'))
        wavFilename = [sampleNames{i} '.wav'];
    else
        wavFilename = sampleNames{i};
    end
    
    % Read the current sample.
    [y, fs] = audioread(wavFilename);
    
    % Create the name of the coded file.
    codedFileName = ['coded' sampleNames{i}];
    
    myEncoder(sampleNames{i}, codedFileName);
    fprintf('Finished Encoding!\n')
    
    myDecoder(codedFileName, codedFileName);
    fprintf('Finished Decoding!\n')
      
    % Append the wav file ending if necessary.
    if isempty(strfind(codedFileName, '.wav'))
        codedWavFilename = [codedFileName '.wav'];
    else
        codedWavFilename = codedFileName;
    end
    
    % Read the compressed file.
    [compressedY, fs] = audioread(codedWavFilename);
    
    % Calculate the error due to the compression.
    e = (y - compressedY).^2;
    totalE = sum(e) / size(e, 1);
    
    load([codedFileName '.mat'])
    
    fprintf('Length of encoded sequence = %d \n', length(b))
    fprintf('MSE = %f\n', totalE(1) + totalE(2));
    
    if playSound
        fprintf('Now playing the original sound file!\n');
        sound(y, fs)
        fprintf('Press any key to play the compressed version!\n');
        pause
        sound(compressedY, fs)
    end
end