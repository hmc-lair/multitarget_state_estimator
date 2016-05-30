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
clear
% clf
% % Read File (est and actual)
error_list_max_sd = zeros(10,1)

for i=1:10
    num_sharks = 10*i;
    filename = strcat('line_pf_max_sd/att_line_pf_', num2str(num_sharks), 'Sharks.txt');
    M = csvread(filename, 3, 0);
    est = M(:,1:2:end-1); % Est Error of shark's distance from line
    act = M(:,2:2:end); % Act Error of shark's distance from line
    
    % Plot Mean
    est_mean = mean(est);
    act_mean = mean(act);

    % Error 
    len = size(est_mean,2);
    for j = 1:len
        % Replace inf with 100
        if est_mean(j)==inf
            est_mean(j)=100;
        end
    end

    error_list_max_sd(i) = sum(abs(est_mean - act_mean));
end
    
num_sharks = linspace(10,100,10)';
plot(num_sharks, error_list_max_sd, '.', 'MarkerSize', 20)
title('Error between estimated and actual over 1000 Timesteps')
ylabel('Diff between est and actual sum of shark distances')
xlabel('Number of Sharks')

save('line_pf_data.mat', 'error_list_max_sd', '-append')
