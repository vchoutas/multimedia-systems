function testQ4()

% Define time
t=0:.01:3;
% Create signal
x=2*cos(2*pi*4*t)+1.4*sin(2*pi*10*t)+(t-1).^2;
% Add some noise
x=x+0.01*rand(size(x));

% Create and ad-hoc quantizer for residuals (it requires your quantLevels.m
addpath ../task3
[Dr,Lr]=quantLevels(8,-10,10);
rmpath ../task3
% .. and for lp coeffs
n=16;
wmin=-50;
wmax=50;

% Call adpcm and inverse
m=5;
[rq,wq]=adpcm(x,Dr,Lr,m,wmin,wmax,n);
xd=iadpcm(rq,wq,Lr,wmin,wmax,n);

% Show results
figure

subplot(2,1,1)
hold on
plot(t,x,'b')
plot(t,xd,'r')
hold off
grid on
legend('actual','decoded')

subplot(2,1,2)
plot(t,(x-xd).^2,'r')
grid on
legend('squarred error')

end
