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

fprintf('Comparing with original signal!\n');
% Compare with the original stream of symbols.
if sum(abs(qi(1:commonLength) - qihat(1:commonLength))) ~= 0
    fprintf('ERROR: Decoding not correct!\n');
    errorIndices = find(abs(qi(1:commonLength) - qihat(1:commonLength)));
    for i = 1 : length(errorIndices)
        fprintf('Error at character %d \n', errorIndices(i));
    end
    fprintf('FAIL\n')
else
    fprintf('PASS\n')
end




if sum(abs(qi-qihat))+nrem==0
    disp('PASS')
else
    disp('FAIL')
end
