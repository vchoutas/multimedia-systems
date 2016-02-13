function y = changefs(x, fs1, fs2)
t1 = 1 :  size(x,2);
t2 = 1 : fs1 / fs2 : size(x,2);

t2 = t2(1 : floor(fs2 / fs1 * (size(x, 2) - 1)));

y = (floor(t2) + 1 - t2).*x(floor(t2)) + (t2 - floor(t2)).*x(floor(t2) + 1);

[L, M] = rat(fs2 / fs1);


% Insert L-1 zeros between every element of the original signal.
tempSignal = kron(x, [1, zeros(1, L - 1)]);
% 
[b, a] = butter(2, min(pi / M, pi / L) / min(2 * pi *[fs1, fs2]));

filteredSignal = filter(b, a, tempSignal);


% for i=1 : size(t2,2)
%     y(i) = (floor(t2(i)) + 1 - t2(i))*x(floor(t2(i))) + (t2(i)-floor(t2(i)))...
%         *x(floor(t2(i)) + 1);
% end

% y = interp1(t1, x, t2);
% fs2/fs1
% M
% floor(fs2 / fs1 * (size(x, 2) - 1))
% size(filteredSignal)
% M
size(y)
tmp = filteredSignal(1:M:length(filteredSignal));
size(tmp)



%
% sum(abs(tmp - y))
% size(filteredSignal)

pause



end