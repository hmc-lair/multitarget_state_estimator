% Gauss Fit MaxDist for attraction line PF
fish_num_list = linspace(10,150,5);
muhat_list_max = zeros(size(fish_num_list,2),1);
sigmahat_list_max = zeros(size(fish_num_list,2),1);

muhat_list_sum = zeros(size(fish_num_list,2),1);
sigmahat_list_sum = zeros(size(fish_num_list,2),1);
N_trial = 3;
clf

for i = 1:size(fish_num_list,2)
    N_fish = fish_num_list(i);
    sum_dist = [];
    max_dist = [];
    
    for j = 1:N_trial
        seg_length = 51;
        [x,y] = fishSim_7(N_fish, seg_length);
        LINE_START = [0 0];
        LINE_END = [seg_length 0];
        for ts = 1:size(x,1)
            sum_shark_dist = totalSharkDistance(x(ts,:), y(ts,:), LINE_START, LINE_END);
            sum_dist = [sum_dist, sum_shark_dist];

            dist_list = zeros(N_fish, 1); % Initialize distance list for timestep
            for f=1:N_fish % Loop through all fish
                dist_list(f) = abs(point_to_line( x(ts,f), y(ts,f), LINE_START, LINE_END));
            end
            max_dist = [max_dist, max(dist_list)];
        end
        disp(j)
    end
    
    
%     hist(max_dist);
    [muhat_max, sigmahat_max] = normfit(max_dist);
    muhat_list_max(i) = muhat_max;
    sigmahat_list_max(i)= sigmahat_max;
    
    [muhat_sum, sigmahat_sum] = normfit(sum_dist);
    muhat_list_sum(i) = muhat_sum;
    sigmahat_list_sum(i)= sigmahat_sum;
    
    disp(i)
end

figure
subplot(2,1,1)
plot(fish_num_list, muhat_list_max, 'x');
title('Gaussian fit of Max Distance') 
ylabel('Mean from Gaussian Fit')
subplot(2,1,2)
plot(fish_num_list, sigmahat_list_max, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')

figure
subplot(2,1,1)
plot(fish_num_list, muhat_list_sum, 'x');
title('Gaussian fit of Sum Distance') 
ylabel('Mean from Gaussian Fit')
subplot(2,1,2)
plot(fish_num_list, sigmahat_list_sum, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')

% save('Data/maxDist.mat', 'num_sharks', 'muhat_list', 'sigmahat_list');

% num_sharks = linspace(10,150,15);
% subplot(2,1,1)
% plot(num_sharks, muhat_list, 'x');
% title('Gaussian fit of sum of shark distances (+/-)') 
% ylabel('Mean from Gaussian Fit')
% subplot(2,1,2)
% plot(num_sharks, sigmahat_list, 'x')
% xlabel('Number of Sharks')
% ylabel('Sigma from Gaussian Fit')

% save('Data/sumdist_gaussfit.mat', 'num_sharks', 'muhat_list', 'sigmahat_list');