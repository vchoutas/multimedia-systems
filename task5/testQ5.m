function testQ5()

% Number of symbols
m=50;

% Length of array
n=1000;

% Some random probabilities
p=rand(m,1);
p=p/sum(p);
% m = 4;
% p = [0.4; 0.35; 0.2; 0.05];

% A random array
qi=randi(m,[n 1]);

% Test

s=huffLUT(p);

b=huff(qi,s);


[qihat,nrem]=ihuff(b,s);

trueLength = length(qi);
recoveredLength = length(qihat);

commonLength = min(trueLength, recoveredLength);

% Compare with the original stream of symbols.
if sum(abs(qi(1:commonLength) - qihat(1:commonLength))) ~= 0
    fprintf('Original Signal Comparison TEST: ERROR, Decoding not correct!\n');
    errorIndices = find(abs(qi(1:commonLength) - qihat(1:commonLength)));
    for i = 1 : length(errorIndices)
        fprintf('Error at character %d \n', errorIndices(i));
    end
    fprintf('Original Signal Comparison TEST: FAIL\n')
else
    fprintf('Original Signal Comparison TEST: PASS\n')
end
% % Alternative test
% [s,tree]=huffLUT(p);
% b=huff(qi,s);
% [qihat,nrem]=ihuff(b,[],tree);


% Compare with MATLAB's built-in function.

symbols = transpose(1:m);

dict = huffmandict(symbols, p); % Create the dictionary.

encodedSignal = huffmanenco(qi, dict); % Encode the data.

decodedSignal = huffmandeco(encodedSignal, dict); % Decode the code.

matlabVersionLength = length(decodedSignal);
recoveredLength = length(qihat);

commonLength = min(matlabVersionLength, recoveredLength);

% Compare with the MATLAB decoded version.
if sum(abs(decodedSignal(1:commonLength) - qihat(1:commonLength))) ~= 0
    fprintf('MATLAB Comparison TEST: ERROR, Decoding not correct!\n');
    errorIndices = find(abs(qi(1:commonLength) - qihat(1:commonLength)));
    for i = 1 : length(errorIndices)
        fprintf('Error at character %d \n', errorIndices(i));
    end
    fprintf('MATLAB Comparison TEST: FAIL\n')
else
    fprintf('MATLAB Comparison TEST: PASS\n')
end

fprintf('Length Comparison Test: ');
if sum(abs(qi-qihat)) + nrem ==0
    disp('PASS')
else
    disp('FAIL')
end
