function y = changefs(x, fs1, fs2)
fs1
fs2
t1 = 1 : 1: size(x,2);
t2 = 1 : fs1/fs2 : size(x,2);
t2 = t2(1 : floor(fs2 / fs1 * (size(x, 2) - 1)));
y = interp1(t1, x, t2);
