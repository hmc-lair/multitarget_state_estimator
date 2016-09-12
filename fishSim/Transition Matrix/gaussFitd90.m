i% Gauss Fit MaxDist and SumDist for attraction line PF
% Independent Variables
seg_list = 10:5:50;
numshark_list = 10:5:200;

seg_list = 10;
numshark_list = [10 15];

% Initialize States
seg_list_len = size(seg_list,2);
numshark_len = size(numshark_list,2);
muhat_list_d90 = zeros(seg_list_len,numshark_len);
sigmahat_list_d90 = zeros(seg_list_len,numshark_len);
N_trial = 10;
clf


% Loop through segment lists
tic
parfor i = 1:seg_list_len
    seg_length = seg_list(i);
    LINE_START = [-seg_length/2 0];
    LINE_END = [seg_length/2 0];
    
%      Loop Through number of shark lists
    for j = 1:numshark_len
        N_fish = numshark_list(j);
        d_90 = zeros(N_trial,1);
    
        for k = 1:N_trial
            disp(N_fish)    
            [xsim,ysim,tsim] = fishSim_7(N_fish,seg_length, 1e3, 1e6, 1e9);
            d_90_trial = tMatrix_d90(xsim,ysim);
            d_90(k) = d_90_trial;
        end

        [muhat_max, sigmahat_max] = normfit(d_90(:))
        muhat_list_d90(i,j) = muhat_max
        sigmahat_list_d90(i,j)= sigmahat_max;   
    end
    
end
toc


save('gaussFitd90_3Trial.mat', 'muhat_list_d90', 'sigmahat_list_d90', ...
    'seg_list', 'numshark_list')

% Plot Gaussian Fit

figure
subplot(2,1,1)
plot(numshark_list, muhat_list_d90, 'x');
title('Gaussian fit of 90th Percentile Max Dist') 
ylabel('Mean from Gaussian Fit')
legend(cellstr(num2str([10 20 30 50 70 100 200]')))
subplot(2,1,2)
plot(numshark_list, sigmahat_list_d90, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')
legend(cellstr(num2str([10 20 30 50 70 100 200]')))
