function [xd] = iadpcm(rq, wq, L, wmin, wmax, n)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[Dw, Lw] = quantLevels(n, wmin, wmax);
w = zeros(length(wq), 1);

m = length(w);

for i = 1:length(w)
    w(i) = iQuant(wq(i), Lw);
end

% xd = zeros(size(rq));
xHat = zeros(length(rq), 1);

dHat = zeros(size(xHat)); 

for i = 1:length(rq)
    dHat(i) = iQuant(rq(i), L);
end

xHat(1:m, 1) = dHat(1:m, 1);
for i = m + 1: length(xHat)
    xHat(i) = dHat(i) + w' * xHat(i:-1:i - m + 1);
end

xd(1:length(rq)) = xHat(1:length(rq), 1);

end

