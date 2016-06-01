muhat_list = zeros(15,1);
sigmahat_list = zeros(15,1);
clf

for i = 1:15
    N_fish = i*10;
    sum_dist = [];
    
    for j = 1:3
        run fishSim_7.m
        load fishSimData.mat

        x_sharks = x(1001:end, :);
        y_sharks = y(1001:end, :);

        for ts = 1:size(x_sharks,1)
            sum_shark_dist = totalSharkDistance(x_sharks(ts,:), y_sharks(ts,:), LINE_START, LINE_END);
            sum_dist = [sum_dist, sum_shark_dist];
        end
    end
    
    
    hist(sum_dist)
    [muhat, sigmahat] = normfit(sum_dist);
    muhat_list(i) = muhat;
    sigmahat_list(i)= sigmahat;
    
    disp(i)
end

num_sharks = linspace(10,150,15);
subplot(2,1,1)
plot(num_sharks, muhat_list, 'x');
title('Gaussian fit of sum of shark distances (+/-)') 
ylabel('Mean from Gaussian Fit')
subplot(2,1,2)
plot(num_sharks, sigmahat_list, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')

save('Data/sumdist_gaussfit.mat', 'num_sharks', 'muhat_list', 'sigmahat_list');