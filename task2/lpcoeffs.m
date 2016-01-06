function w = lpcoeffs(x,m)
R = corr(x');
r = R(1, 1: end );
m
w = levinson(r,m-1)'
size(w)
% pause
% r = R(1,end - m :end);
% size(r)
% R1 = R(end - m:end -1, end - m:end -1);
% size(R1)
% w = inv(R1)*r;    