% Reads shark mean position estimate log file from att_line_pf.py and
% plots


% % Read File
% M = csvread('testError20_20_0525.txt');
% 
% x_20 = M; % Error of shark's distance from line
% 
% plot(x_20');
% xlabel('Time (s)');
% ylabel('y distance from att (m)')
% title('Error in Distance From Line')
% 
% % Plot Mean
% xmean_20 = mean(x_20);
% figure
% plot(xmean_20')
% title('Mean Error in Distance From Line')

plot(xmean_20');
hold on 
plot(xmean_50');
label('20', '50')
hold off
