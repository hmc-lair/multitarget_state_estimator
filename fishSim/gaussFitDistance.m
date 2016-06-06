% Gauss Fit SumDist for attraction line PF

muhat_list = zeros(15,1);
sigmahat_list = zeros(15,1);
N_trial = 3;
clf

for i = 1:15
    N_fish = i*10;
    sum_dist = [];
    max_dist = [];
    
    for j = 1:N_trial
        run fishSim_7.m
        load fishSimData.mat

        for ts = 1:size(x,1)
%             sum_shark_dist = totalSharkDistance(x(ts,:), y(ts,:), LINE_START, LINE_END);
%             sum_dist = [sum_dist, sum_shark_dist];

            dist_list = zeros(N_fish, 1); % Initialize distance list for timestep
            for f=1:N_fish % Loop through all fish
                dist_list(f) = abs(point_to_line( x(ts,f), y(ts,f), LINE_START, LINE_END));
            end
            max_dist = [max_dist, max(dist_list)];
        end
        disp(j)
    end
    
    
    hist(max_dist);
    [muhat, sigmahat] = normfit(max_dist);
    muhat_list(i) = muhat;
    sigmahat_list(i)= sigmahat;
    
    disp(i)
end

num_sharks = linspace(10,150,15);
subplot(2,1,1)
plot(num_sharks, muhat_list, 'x');
title('Gaussian fit of Max Distance') 
ylabel('Mean from Gaussian Fit')
subplot(2,1,2)
plot(num_sharks, sigmahat_list, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')

save('Data/maxDist.mat', 'num_sharks', 'muhat_list', 'sigmahat_list');

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