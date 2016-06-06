% Experiment to see the percentage of tags needed
load actual_tracks.mat ...
    x y t

x = x';
y = y';
t = t';
threshold = 0.1;
N_trial = 1;

% Line endpoints from actual data (from Kim)
LINE_START = [-25 5.533];
LINE_END = [25 -5.3070];
N_fish = 112;

ts_pf = 800;

% act_pf_perf = zeros(11, N_trial);
act_error_list = zeros(ts_pf, 3);
est_error_list = zeros(ts_pf, 3);
error_list = zeros(ts_pf, 3);
tag_x = linspace(3,11,5);


for i = 1
    for j = 1:N_trial
        N_tagged = 112;
        [act_error_list(:,i), est_error_list(:,i), error_list(:,i)] = att_pf(x, y, t, N_tagged, LINE_START, LINE_END, ts_pf);
%         error_112 = att_error;
%         act_pf_perf(i, j) = size(find(error < threshold),1)
    end
end

subplot(2,1,1)
hold on
plot(act_error_list(:,1), '.')
plot(est_error_list, '.')
legend('Actual Line', '30 Tagged', '50','70', '90', '110')
title(sprintf('Comparison of Sum of Distance to Actual and Estimated Line for 112 Sharks', N_tagged, N_fish));
hold off

subplot(2,1,2)
plot(error_list, '.')
legend('30 Tagged', '50','70', '90', '110')
title('Performance Error (sqrt(\Sigma(dist\_act\_i - dist\_est\_i)^2)/numshark)')
