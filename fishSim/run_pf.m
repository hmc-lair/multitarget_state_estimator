% Run att_pf and graph performance
clf

% load actual_tracks.mat ...
%     x y t
% 

N_trial = 3;

tag_list = [60 80 100];
ts_pf = 1000;
N_fish = 100;


tag_list_size = size(tag_list, 2);
act_error_list = zeros(ts_pf, 1);
est_error_list = zeros(ts_pf, tag_list_size);
error_list = zeros(ts_pf, tag_list_size);
numshark_est_list = zeros(ts_pf, tag_list_size);
error_list = zeros(ts_pf, tag_list_size);
seglen_list = zeros(ts_pf, tag_list_size);
tagrange_list = zeros(ts_pf, tag_list_size);

for i = 1:tag_list_size
    
    act_error_tag = zeros(ts_pf, N_trial);
    est_error_tag = zeros(ts_pf, N_trial);
    error_tag = zeros(ts_pf, N_trial);
    numshark_est_tag = zeros(ts_pf, N_trial);
    seglen_est_tag = zeros(ts_pf, N_trial);
    tagrange = zeros(ts_pf, N_trial);
    
    N_tag = tag_list(i);
    
    for j = 1:N_trial
        seg_length = 50;
        [x,y,t] = fishSim_7(N_fish,seg_length);
        LINE_START = [-seg_length/2 0];
        LINE_END = [seg_length/2 0];
        [act_error, est_error, error, numshark_est, x_robots, y_robots, numtag_range, seg_len] = ...
    att_pf(x, y, t, N_tag, LINE_START, LINE_END, ts_pf, false)
      
        act_error_tag(:,j) = act_error;
        est_error_tag(:,j) = est_error;
        error_tag(:,j) = error;
        numshark_est_tag(:,j) = numshark_est;
        seglen_est_tag(:,j) = seg_len;
        tagrange(:,j) = numtag_range;
    end
       
    
    act_error_list(:,i) = mean(act_error_tag,2);
    est_error_list(:,i) = mean(est_error_tag,2);
    error_list(:,i) = mean(error_tag, 2);
    numshark_est_list(:,i) = mean(numshark_est, 2);
    seglen_list(:,i) = mean(seglen_est_tag, 2);
    tagrange_list(:,i) = mean(tagrange,2);
end

% Plot Performance of attraction line PF
% subplot(3,1,1)
% hold on
% plot(act_error_list(:,1), '.')
% plot(est_error_list, '.')
% legend('Actual Line', '20 Tagged', '40', '60', '80', '100')
% title(sprintf('Comparison of Sum of Distance to Act and Est Line for %d Sharks with sigma=1 and uni(0,5)', N_fish));
% hold off

subplot(2,2,1)
plot(error_list, '.')
title({'Performance Error','(\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2/numshark)))'})
legend('20 Tagged', '30', '40', '50')

subplot(2,2,2)
hold on
plot([0 ts_pf], [N_fish N_fish]);
plot(numshark_est_list, '.');
% ylim([0 200]);
legend('Actual Line','60', '80', '100')
title({'Comparison of Actual', 'and Estimated Number of Sharks'})
xlabel('Number of Steps')
hold off

subplot(2,2,3)
hold on
plot([0 ts_pf], [seg_length seg_length]);
plot(seglen_list, '.');
% ylim([0 200]);
legend('Actual Line','60', '80', '100')
title({'Comparison of Actual','and Estimated Segment Length'})
xlabel('Number of Steps')
hold off

subplot(2,2,4)
hold on
plot(tagrange_list, '.');
% ylim([0 200]);
legend('60', '80', '100')
title({'Number of Tags', 'in Range'})
xlabel('Number of Steps')
hold off
