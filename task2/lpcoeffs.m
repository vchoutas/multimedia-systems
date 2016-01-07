function w=lpcoeffs(x,m)

[R1,lags] = xcorr(x);
R1 = R1(lags>=0);
R = toeplitz(R1(1:m));
r = R1(2:m+1);
w = R\r;