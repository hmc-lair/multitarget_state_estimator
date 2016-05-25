% Reads shark mean position estimate log file from att_line_pf.py and
% plots


% % Read File
M = csvread('testError50_50_0525random.txt');

x_50 = M; % Error of shark's distance from line

plot(x_50', '.');
xlabel('Time (s)');
ylabel('y distance from att (m)')
title('Error in Distance From Line')

% Plot Mean
xmean_50 = mean(x_50);
figure
plot(xmean_50', '.')
title('Mean Error in Distance From Line')


% subplot(2,1,1)
% plot(x_20');
% subplot(2,1,2)
% plot(x_50');
% hold off
