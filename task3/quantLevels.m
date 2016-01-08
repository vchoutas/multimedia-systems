function [D, L] = quantLevels(n, xmin, xmax)
k = 2 ^ n;

Delta = (xmax - xmin) / (k);
L(1) = xmin + Delta/2;
for i = 2 : k
    L(i) = L(i-1) + Delta;
end
for i =1:k-1
    D(i) = (L(i) + Delta/2);
end