% Gauss Fit MaxDist for attraction line PF

% Gauss Fit SumDist for attraction line PF
seg_list = [10 20 30 50 70 100 200];
numshark_list = [10 30 50 80 100 200];

seg_list_len = size(seg_list,2);
numshark_len = size(numshark_list,2);
muhat_list_max_area = zeros(seg_list_len,numshark_len);
sigmahat_list_max_area = zeros(seg_list_len,numshark_len);
muhat_list_sum = zeros(seg_list_len,numshark_len);
sigmahat_list_sum = zeros(seg_list_len,numshark_len);
N_trial = 3;
clf

tic
parfor i = 1:seg_list_len
    seg_length = seg_list(i);
    LINE_START = [-seg_length/2 0];
    LINE_END = [seg_length/2 0];
    
    
    for j = 1:numshark_len
        N_fish = numshark_list(j)
%         sum_dist = zeros(N_trial, 2000);
        max_dens = zeros(N_trial, 2000);
        
        for k = 1:N_trial
                  
            [x,y,t] = fishSim_7(N_fish,seg_length);
            for ts = 1:size(x,1)

%                 sum_shark_dist = totalSharkDistance(x(ts,:), y(ts,:), LINE_START, LINE_END);
%                 sum_dist(k,ts) = sum_shark_dist;

                dist_list = zeros(N_fish, 1); % Initialize distance list for timestep
                for f=1:N_fish % Loop through all fish
                    dist_list(f) = abs(point_to_line( x(ts,f), y(ts,f), LINE_START, LINE_END));
                end
                area = max(dist_list) * seg_length;
                max_dens(k,ts) = N_fish/area;
            end
        end
        
        max_dens = max_dens(:);
%         sum_dist = sum_dist(:);
        
        [muhat_max, sigmahat_max] = normfit(max_dens);
        muhat_list_max_area(i,j) = muhat_max
        sigmahat_list_max_area(i,j)= sigmahat_max;
% 
%         [muhat_sum, sigmahat_sum] = normfit(sum_dist);
%         muhat_list_sum(i,j) = muhat_sum;
%         sigmahat_list_sum(i,j)= sigmahat_sum;
    
    end
    
    disp(i)
end

toc

figure
subplot(2,1,1)
plot(numshark_list, muhat_list_max_area, 'x');
title('Gaussian fit of Max Area') 
ylabel('Mean from Gaussian Fit')
legend(cellstr(num2str([10 20 30 50 70 100 200]')))
subplot(2,1,2)
plot(numshark_list, sigmahat_list_max_area, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')
legend(cellstr(num2str([10 20 30 50 70 100 200]')))

figure
subplot(2,1,1)
plot(numshark_list, muhat_list_sum, 'x');
title('Gaussian fit of Sum Distance') 
ylabel('Mean from Gaussian Fit')
legend(cellstr(num2str([10 20 30 50 70 100 200]')))
subplot(2,1,2)
plot(numshark_list, sigmahat_list_sum, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')
legend(cellstr(num2str([10 20 30 50 70 100 200]')))
