clear all
close all


for i = 1:4
    [y, fs] = wavread(['sample' num2str(i)]);
    
    figure;
    histogram(y(:, 1));
    
    figure;
    histogram(y(:, 2));
end