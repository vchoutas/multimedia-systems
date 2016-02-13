function y = changefs(x, fs1, fs2, interpMethod)

if nargin < 4
    interpMethod = 'linear';
end

t1 = 1:length(x);
tq = 1 : fs1 / fs2 : size(x,2);

y = interp1(t1, x, tq, interpMethod);

y = y(1:floor(fs2 / fs1 * (length(x) - 1)));

end



