M = csvread('testError50.txt', 1);

x = M(1:2:end,:); % odd matrix (x position)
y = M(2:2:end,:); % even matrix (y position)
xmean = mean(x);  % odd matrix
ymean = mean(y);  % odd matrix

subplot(2,1,1);
plot(x');
subplot(2,1,2);
plot(y');
% plot(y');
% legend('10','20','30','40','50')