function [rq, wq]=adpcm(x, D, L, m, wmin, wmax, n)
addpath ../task3/
addpath ../task2/
[Dw, Lw] = quantLevels(n, wmin, wmax);
x = x';
w=lpcoeffs(x, m);

for i =1:length(w)
    wq(i) = Quant(w(i), Dw); 
end

r = x(1);
rq = Quant(r, D);

for i =2 : length(x)
    if i <= m
        r(i) = x(i) - w(1:i-1)'*x(i-1 :-1 : 1);
        rq(i) = Quant(r(i), D); 
        x(i) = iQuant(rq(i), L) + w(1:i-1)'*x(i-1:-1: 1);
        
    else
        r(i) = x(i) - w'*x(i-1 : -1 :i -m);
        rq(i) = Quant(r(i), D);
        x(i) = iQuant(rq(i), L) + w' * x(i-1 : -1 :i -m);
    end    
end      
