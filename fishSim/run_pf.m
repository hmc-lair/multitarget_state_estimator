% Run att_pf and graph performance
clf

% load actual_tracks.mat ...
%     x y t
% 

N_trial = 3;
tag_list = [25, 50];
ts_pf = 1000;
N_fish = 50;
seg_length = 25;

% Preallocate List
tag_list_size = size(tag_list, 2);
act_error_list = zeros(ts_pf, 1);
est_error_list = zeros(ts_pf, tag_list_size);
error_list = zeros(ts_pf, tag_list_size);
numshark_est_list = zeros(ts_pf, tag_list_size);
error_list = zeros(ts_pf, tag_list_size);
seglen_list = zeros(ts_pf, tag_list_size);
d90_list = zeros(ts_pf, tag_list_size);

for i = 1:tag_list_size
    
    act_error_tag = zeros(ts_pf, N_trial);
    est_error_tag = zeros(ts_pf, N_trial);
    error_tag = zeros(ts_pf, N_trial);
    numshark_est_tag = zeros(ts_pf, N_trial);
    seglen_est_tag = zeros(ts_pf, N_trial);
    d90_est_tag = zeros(ts_pf, N_trial);
    
    N_tag = tag_list(i);
    
    for j = 1:N_trial
        
        [x,y,t] = fishSim_7(N_fish,seg_length, 1e3, 1e6, 1e9);
        LINE_START = [-seg_length/2 0];
        LINE_END = [seg_length/2 0];
        [act_error, est_error, error, numshark_est, x_robots, y_robots, numtag_range, seg_len_est, d90_est] = att_pf(x, y, t, LINE_START, LINE_END, ts_pf, false);
        
        % Assign to lists
        act_error_tag(:,j) = act_error;
        est_error_tag(:,j) = est_error;
        error_tag(:,j) = error;
        numshark_est_tag(:,j) = numshark_est;
        seglen_est_tag(:,j) = seg_len_est;
        d90_est_tag(:,j) = d90_est;
    end
       
    % Average Across Trials
    act_error_list(:,i) = mean(act_error_tag,2);
    est_error_list(:,i) = mean(est_error_tag,2);
    error_list(:,i) = mean(error_tag, 2);
    numshark_est_list(:,i) = mean(numshark_est, 2);
    seglen_list(:,i) = mean(seglen_est_tag, 2);
    d90_list(:,i) = mean(d90_est_tag, 2);
end

save('pf_line.mat', 'act_error_list', 'est_error_list', 'error_list','numshark_est_list',...
    'ts_pf','N_fish','tag_list','seglen_list', 'd90_list')
%
% % Plot Performance of attraction line PF
% subplot(3,1,1)
% hold on
% plot(act_error_list(:,1), '.')
% plot(est_error_list, '.')
% legend('Actual Line', '20 Tagged', '40', '60', '80', '100')
% title(sprintf('Comparison of Sum of Distance to Act and Est Line for %d Sharks with sigma=1 and uni(0,5)', N_fish));
% hold off
% 
% subplot(3,1,2)
% plot(error_list, '.')
% title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2/numshark)))')
% legend('20 Tagged', '40', '60', '80', '100')
% 
% subplot(3,1,3)
% hold on
% plot([0 ts_pf], [N_fish N_fish]);
% plot(numshark_est_list, '.');
% % ylim([0 200]);
% legend('Actual Line','20 Tagged', '40', '60', '80', '100')
% title('Comparison of Actual and Estimated Number of Sharks')
% xlabel('Number of Steps')
% hold off