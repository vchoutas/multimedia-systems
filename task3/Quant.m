function q = Quant(x, D)


k = length(D);
q = 1;
for i = k : -1 : 1
    if x > D(i)
        q = i + 1;
        break;
    end
end
