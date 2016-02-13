function xd=iadpcm(rq, wq, L,wmin,wmax,n)
addpath ../task3/
addpath ../task2/
[Dw, Lw] = quantLevels(n, wmin, wmax);

for i = 1:length(rq)
    r(i) = iQuant(rq(i), L);
end
for i = 1:length(wq)
    w(i) = iQuant(wq(i), Lw);
end
xd = r(1);
m = length(w);
for i =2 : length(r)
    if i <= m
        xd(i) = r(i) + w(1:i-1)*xd(i-1 :-1 : 1)';
    else
        xd(i) = r(i) + w*xd(i-1 : -1 :i -m)';
    end
end
