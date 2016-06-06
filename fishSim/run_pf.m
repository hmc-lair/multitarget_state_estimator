% Run att_pf and graph performance
clf

% load actual_tracks.mat ...
%     x y t
% 
% x = x';
% y = y';
% t = t';
% threshold = 0.1;
% N_trial = 1;

% Line endpoints from actual data (from Kim)
% N_fish = 110;
N_tag = N_fish;

ts_pf = 800;

%Variables
% ts_pf = 1000;
% N_tag = 100;
[act_error, est_error, error, numshark_est] = att_pf(x, y, t, N_tag, LINE_START, LINE_END, ts_pf);

% Plot Performance of attraction line PF
subplot(3,1,1)
hold on
plot(act_error, '.')
plot(est_error, '.')
legend('Actual Line', 'Estimated Line')
title(sprintf('Comparison of Sum of Distance to Act and Est Line for %d Sharks with sigma=1 and uni(0,0.1)', N_fish));
hold off

subplot(3,1,2)
plot(error, '.')
title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2/numshark)))')

subplot(3,1,3)
hold on
plot([0 ts_pf], [N_fish N_fish]);
plot(numshark_est, '.');
ylim([0 200]);
legend('Actual', 'Estimated')
title('Comparison of Actual and Estimated Number of Sharks')
xlabel('Number of Steps')
hold off