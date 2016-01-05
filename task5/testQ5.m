function testQ5()

% Number of symbols
m=50;

% Length of array
n=1000;

% Some random probabilities
p=rand(m,1);
p=p/sum(p);

% A random array
qi=randi(m,[n 1]);

% Test
s=huffLUT(p);
b=huff(qi,s);
[qihat,nrem]=ihuff(b,s);

% % Alternative test
% [s,tree]=huffLUT(p);
% b=huff(qi,s);
% [qihat,nrem]=ihuff(b,[],tree);

if sum(abs(qi-qihat))+nrem==0
    disp('PASS')
else
    disp('FAIL')
end
