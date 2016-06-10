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

tag_list = [30 40 50 70 90 100];
ts_pf = 4000;
% Line endpoints from actual data (from Kim)
% N_fish = 110;
% N_tag = N_fish;

% tag_list =linspace(10,50,5);
LINE_START = [-25 5.533]; % Actual Line
LINE_END = [25 -5.3070];


tag_list_size = size(tag_list, 2);
act_error_list = zeros(ts_pf, 1);
est_error_list = zeros(ts_pf, tag_list_size);
error_list = zeros(ts_pf, tag_list_size);
numshark_est_list = zeros(ts_pf, tag_list_size);
error_list = zeros(ts_pf, tag_list_size);

for i = 1:tag_list_size

    N_tag = tag_list(i)
    [act_error, est_error, error, numshark_est] = att_pf(x, y, t, N_tag, LINE_START, LINE_END, ts_pf, false);
    act_error_list(:,i) = act_error;
    est_error_list(:,i) = est_error;
    error_list(:,i) = error;
    numshark_est_list(:,i) = numshark_est;
end

% Plot Performance of attraction line PF
subplot(3,1,1)
hold on
plot(act_error_list, '.')
plot(est_error_list, '.')
legend('Actual Line', '30 Tagged', '40', '50', '70', '90', '100')
title(sprintf('Comparison of Sum of Distance to Act and Est Line for %d Sharks with sigma=1 and uni(0,5)', N_fish));
hold off

subplot(3,1,2)
plot(error_list, '.')
title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2/numshark)))')
legend('30 Tagged', '40', '50', '70', '90', '100')

subplot(3,1,3)
hold on
plot([0 ts_pf], [N_fish N_fish]);
plot(numshark_est_list, '.');
ylim([0 200]);
legend('Actual', '30 Tagged', '40', '50', '70', '90', '100')
title('Comparison of Actual and Estimated Number of Sharks')
xlabel('Number of Steps')
hold off