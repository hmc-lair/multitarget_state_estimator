% Reads shark mean position estimate log file from att_line_pf.py and
% plots

% 
% % % Read File
% M = csvread('catalina_error.txt');
% 
% x = M; % Error of shark's distance from line
% 
% plot(x', '.');
% xlabel('Time (s)');
% ylabel('y distance from att (m)')
% title('Error in Distance From Line')
% 
% % Plot Mean
% x = mean(x);
% figure
% plot(x', '.')
% title('Mean Error in Distance From Line')


% % Read File (est and actual)
M = csvread('att_line_pf_140Sharks.txt', 3, 0);
est = M(:,1:2:end); % Est Error of shark's distance from line
act = M(:,2:2:end); % Act Error of shark's distance from line

hold on
plot(est', '.');
plot(act', 'x');
hold off

xlabel('Time (s)');
ylabel('Total Shark Distance from line')
title('Error in Distance From Line')

% Plot Mean
est_mean = mean(est);
act_mean = mean(act);
figure
hold on
plot(est_mean', '.')
plot(act_mean', '-')
legend('Est', 'Act')
xlabel('Time (s)');
ylabel('Total Shark Distance from line')
title('Mean Error in Distance From Line')
% 