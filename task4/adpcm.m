function [rq, wq] = adpcm(x, D, L, m , wmin, wmax, n)
%ADPCM Perfoms Adaptive Pulse Code Modulation for the input signal 

wq  = zeros(m, 1);
w = lpcoeffs(x, m);

[Dw, Lw] = quantLevels(n, wmin, wmax);
for i = 1:length(w)
    wq(i) = Quant(w(i), Dw);
end

rq = zeros(size(x));
xHat = zeros(length(x), 1);
for i = 1:m
    xHat(i) = x(i);
    rq(i) = Quant(x(i), D);
end


for i=m + 1:length(x)
    d = x(i) - w' * xHat(i:-1:i - m + 1);    
    rq(i) = Quant(d, D);    
    xHat(i) = iQuant(rq(i), L) + w' * xHat(i:-1:i - m + 1);
end



end

