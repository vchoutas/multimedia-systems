clear all
close all

% A simple script used to plot the histograms of each channel for every
% signal in order to view their distributions.
for i = 1:4
    [y, fs] = wavread(['sample' num2str(i)]);
    
    figure;
    histogram(y(:, 1));
    
    figure;
    histogram(y(:, 2));
end