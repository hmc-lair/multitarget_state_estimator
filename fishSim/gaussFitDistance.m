% Gauss Fit SumDist for attraction line PF
seg_list = [10 20 30 50 100 200];
density_list = [0.1 0.2 0.5 1 3];
seg_list_len = size(seg_list,2);
den_list_len = size(density_list,2);
muhat_list_max = zeros(seg_list_len,den_list_len);
sigmahat_list_max = zeros(seg_list_len,den_list_len);
muhat_list_sum = zeros(seg_list_len,den_list_len);
sigmahat_list_sum = zeros(seg_list_len,den_list_len);
N_trial = 3;
clf

for i = 1:seg_list_len
    seg_length = seg_list(i);
    LINE_START = [-seg_length/2 0];
    LINE_END = [seg_length/2 0];
    
    for j = 1:den_list_len
        density = density_list(j)
        N_fish = density * seg_length;
        sum_dist = [];
        max_dist = [];
        
        for k = 1:N_trial
                  
            [x,y,t] = fishSim_7(density,seg_length);
            for ts = 1:size(x,1)

                sum_shark_dist = totalSharkDistance(x(ts,:), y(ts,:), LINE_START, LINE_END);
                sum_dist = [sum_dist, sum_shark_dist];
                
                dist_list = zeros(N_fish, 1); % Initialize distance list for timestep
                for f=1:N_fish % Loop through all fish
                    dist_list(f) = abs(point_to_line( x(ts,f), y(ts,f), LINE_START, LINE_END));
                end
                max_dist = [max_dist, max(dist_list)];
            end
        end    
    
%     hist(max_dist);
        [muhat_max, sigmahat_max] = normfit(max_dist);
        muhat_list_max(i,j) = muhat_max
        sigmahat_list_max(i,j)= sigmahat_max;

        [muhat_sum, sigmahat_sum] = normfit(sum_dist);
        muhat_list_sum(i,j) = muhat_sum;
        sigmahat_list_sum(i,j)= sigmahat_sum;
    
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

plot(seg_list, muhat_list_max, 'x');
legend('0.1 Sharks/m','0.2','0.5','1','3')
title('Gaussian fit of Max Distance with varying density and segment length') 

ylabel('Mean from Gaussian Fit')
subplot(2,1,2)
plot(seg_list, sigmahat_list_max, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')
legend('0.1 Sharks/m','0.2','0.5','1','3')

figure
subplot(2,1,1)
plot(seg_list, muhat_list_sum, 'x');
title('Gaussian fit of Sum Distance with varying density and segment length') 

ylabel('Mean from Gaussian Fit')
legend('0.1 Sharks/m','0.2','0.5','1','3')
subplot(2,1,2)
plot(seg_list, sigmahat_list_sum, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')

