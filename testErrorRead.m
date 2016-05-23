% Reads shark mean position estimate log file from mean_point_pf.py and
% plots


% Read File
M = csvread('testError50_0523.txt');

x = M(1:2:end,:); % odd matrix (x position)
y = M(2:2:end,:); % even matrix (y position)
xmean = mean(x);  % odd matrix
ymean = mean(y);  % odd matrix

subplot(2,1,1);
plot(x');
ylim([-2 2]);
ylabel('x distance from att (m)')
subplot(2,1,2);
plot(y');
ylim([-2 2]);
xlabel('Time (s)');
ylabel('y distance from att (m)')

% Plot Mean
figure
subplot(2,1,1);
plot(xmean)
ylim([-2 2]);
subplot(2,1,2);
plot(ymean)
ylim([-2 2]);
