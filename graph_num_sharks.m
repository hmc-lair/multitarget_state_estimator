mean_num = zeros(10,1);
sd_num = zeros(10,1);

for i = 1:10
    string = strcat('line_pf_vary_sd/att_numsharks_', num2str(i*10), 'Sharks.txt');
    M = csvread(string, 0);
    M = M(1,1:end-1);
    
    re_M = reshape(M, [5,1000]);
    mean_num(i) = nanmean(re_M, 1);
    sd_num(i) = nanstd(re_M, 1);

    % mean_shark = mean(M)
    % plot(mean_M, '.')
end
% 
num_sharks = linspace(10,100,10)';

subplot(2,1,1)
plot(num_sharks, mean_num, '.', 'MarkerSize', 25)
hold on
plot(num_sharks, num_sharks, 'x', 'MarkerSize', 25)
legend('Estimated', 'Actual')
xlabel('Number of Sharks')
ylabel('Estimated Mean Number of Sharks')
title('Est vs. Actual Number of Sharks (over 1000 Ts and 5 Trials)')
hold off

subplot(2,1,2)
plot(num_sharks, sd_num, '.', 'MarkerSize', 25)
xlabel('Number of Sharks')
ylabel('Estimated Mean Sd of Sharks')
title('s.d. in Estimated Number of Sharks (over 1000 Ts and 5 Trials)')