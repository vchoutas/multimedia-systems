function y = changefs(x, fs1, fs2)
t1 = 1 :  size(x,2);
t2 = 1 : fs1 / fs2 : size(x,2);
t2 = t2(1 : floor(fs2 / fs1 * (size(x, 2) - 1)));


% for i=1 : size(t2,2)
%     y(i) = (floor(t2(i)) + 1 - t2(i))*x(floor(t2(i))) + (t2(i)-floor(t2(i)))...
%         *x(floor(t2(i)) + 1);
% end
y = (floor(t2) + 1 - t2).*x(floor(t2)) + (t2 - floor(t2)).*x(floor(t2) + 1);
% y = interp1(t1, x, t2);



