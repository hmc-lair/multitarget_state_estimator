% Gauss Fit MaxDist and SumDist for attraction line PF
% Independent Variables
seg_list = 10:5:50;
numshark_list = 10:10:150;
% Initialize States
seg_list_len = size(seg_list,2);
numshark_len = size(numshark_list,2);
muhat_list_d90 = zeros(seg_list_len,numshark_len);
sigmahat_list_d90 = zeros(seg_list_len,numshark_len);
muhat_list_x90 = zeros(seg_list_len,numshark_len);
sigmahat_list_x90 = zeros(seg_list_len,numshark_len);
N_trial = 3;
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
        x_90 = zeros(N_trial,1);
    
        for k = 1:N_trial
            disp(N_fish)    
            [xsim,ysim,tsim] = fishSim_7(N_fish,seg_length, 1e3, 1e6, 1e9);
            [x_90_trial, d_90_trial] = tMatrix_d90(xsim,ysim);
            d_90(k) = d_90_trial;
            x_90(k) = x_90_trial;
        end

        [muhat_max, sigmahat_max] = normfit(d_90(:))
        muhat_list_d90(i,j) = muhat_max
        sigmahat_list_d90(i,j)= sigmahat_max;   
        [muhat_x90, sigmahat_x90] = normfit(x_90(:))
        muhat_list_x90(i,j) = muhat_x90
        sigmahat_list_x90(i,j)= sigmahat_x90;   
    end
    
end
toc


save('gaussFitd90_3Trial.mat', 'muhat_list_d90', 'sigmahat_list_d90', 'muhat_list_x90','sigmahat_list_x90', ...
    'seg_list', 'numshark_list')

