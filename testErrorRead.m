M = csvread('testError40.txt');

x = M(1:2:end,:); % odd matrix (x position)
y = M(2:2:end,:); % even matrix (y position)
xmean = mean(x);  % odd matrix
ymean = mean(y);  % odd matrix

xmean_40 = xmean;
ymean_40 = ymean;

subplot(2,1,1);
plot(x');
% plot(xmean);
ylabel('x distance from att (m)')
subplot(2,1,2);
plot(y');
% plot(ymean);
xlabel('Time (s)');
ylabel('y distance from att (m)')

% Save Data
save('mean.mat','xmean_40', 'ymean_40', '-append')